import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'sim_snapshot.dart';
import 'xplane_client.dart';
import 'xplane_datarefs.dart';

/// A live WebSocket session with X-Plane: subscribes to the app's datarefs
/// and streams [SimSnapshot]s (X-Plane pushes changes at 10 Hz).
class XPlaneLiveSession {
  XPlaneLiveSession._(this._socket, this._ids, this.version) {
    _names = {for (final e in _ids.entries) e.value: e.key};
    _socket.listen(
      _onMessage,
      onDone: _finish,
      onError: (Object e) => _finish(e),
      cancelOnError: true,
    );
  }

  /// Connects and subscribes. Throws [XPlaneException] with message
  /// `noFlight` while X-Plane has no flight loaded (no datarefs yet).
  static Future<XPlaneLiveSession> connect({
    required String host,
    required int port,
    http.Client? client,
    Duration timeout = const Duration(seconds: 6),
  }) async {
    final rest = XPlaneClient(host: host, port: port, client: client);
    try {
      final info = await rest.capabilities().catchError(
        (Object _) => const XPlaneInfo(version: null, apiVersions: []),
      );
      final base = await rest.apiBase();
      final ids = await rest.resolveDatarefs(base, XPlaneDatarefs.all);
      if (!ids.containsKey(XPlaneDatarefs.latitude)) {
        throw const XPlaneException('noFlight');
      }
      final WebSocket socket;
      try {
        socket = await WebSocket.connect('ws://$host:$port$base')
            .timeout(timeout);
      } on TimeoutException {
        throw const XPlaneException('timeout');
      } on Object catch (e) {
        throw XPlaneException('$e');
      }
      final session = XPlaneLiveSession._(socket, ids, info.version);
      session._send('dataref_subscribe_values', {
        'datarefs': [
          for (final id in ids.values) {'id': id},
        ],
      });
      return session;
    } finally {
      rest.close();
    }
  }

  final WebSocket _socket;
  final Map<String, int> _ids;
  late final Map<int, String> _names;

  /// X-Plane version, if it reported one.
  final String? version;

  final _values = <String, Object?>{};
  final _snapshots = StreamController<SimSnapshot>.broadcast();
  final _done = Completer<Object?>();
  var _nextReqId = 1;
  SimSnapshot? _latest;

  Stream<SimSnapshot> get snapshots => _snapshots.stream;
  SimSnapshot? get latest => _latest;

  /// Completes when the connection ends, with the error if there was one.
  Future<Object?> get done => _done.future;

  void _send(String type, Map<String, Object?> params) {
    if (_done.isCompleted) return;
    _socket.add(
      jsonEncode({'req_id': _nextReqId++, 'type': type, 'params': params}),
    );
  }

  void _onMessage(dynamic message) {
    // Messages still buffered in the socket after close() are dropped.
    if (message is! String || _done.isCompleted) return;
    final Object? json;
    try {
      json = jsonDecode(message);
    } on FormatException {
      return;
    }
    if (json is! Map) return;
    if (json['type'] == 'dataref_update_values' && json['data'] is Map) {
      for (final MapEntry(:key, :value) in (json['data'] as Map).entries) {
        final name = _names[int.tryParse('$key'.trim())];
        if (name != null) _values[name] = value;
      }
      final snapshot = XPlaneDatarefs.snapshot(_values);
      _latest = snapshot;
      _snapshots.add(snapshot);
    }
  }

  /// Tunes the active or standby frequency of [radio] (kHz).
  bool tune(SimRadio radio, int khz, {required bool standby}) {
    final id = _ids[XPlaneDatarefs.radio(radio, standby: standby)];
    if (id == null) return false;
    _send('dataref_set_values', {
      'datarefs': [
        {'id': id, 'value': XPlaneDatarefs.toRaw(radio, khz)},
      ],
    });
    return true;
  }

  /// Exchanges active and standby frequency of [radio].
  bool swap(SimRadio radio) {
    final t = _latest?.radios[radio];
    final active = t?.active;
    final standby = t?.standby;
    if (active == null || standby == null) return false;
    return tune(radio, standby, standby: false) &&
        tune(radio, active, standby: true);
  }

  void _finish([Object? error]) {
    if (_done.isCompleted) return;
    _done.complete(error);
    _snapshots.close();
  }

  Future<void> close() async {
    await _socket.close();
    _finish();
  }
}
