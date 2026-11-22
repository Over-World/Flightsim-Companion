import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/settings.dart';
import '../../data/sim/sim_snapshot.dart';
import '../../data/sim/xplane_client.dart';
import '../../data/sim/xplane_live.dart';

/// What the app needs from a live simulator connection.
abstract interface class SimSession {
  String? get version;
  Stream<SimSnapshot> get snapshots;

  /// Completes when the connection ends.
  Future<Object?> get done;
  bool tune(SimRadio radio, int khz, {required bool standby});
  bool swap(SimRadio radio);
  Future<void> close();
}

typedef SimConnector = Future<SimSession> Function(String host, int port);

class _XPlaneSession implements SimSession {
  _XPlaneSession(this._live);

  final XPlaneLiveSession _live;

  @override
  String? get version => _live.version;
  @override
  Stream<SimSnapshot> get snapshots => _live.snapshots;
  @override
  Future<Object?> get done => _live.done;
  @override
  bool tune(SimRadio radio, int khz, {required bool standby}) =>
      _live.tune(radio, khz, standby: standby);
  @override
  bool swap(SimRadio radio) => _live.swap(radio);
  @override
  Future<void> close() => _live.close();
}

Future<SimSession> connectXPlane(String host, int port) async =>
    _XPlaneSession(await XPlaneLiveSession.connect(host: host, port: port));

enum SimStatus {
  /// No host set or live connection switched off.
  off,
  connecting,

  /// X-Plane answers but has no flight loaded yet.
  waitingForFlight,
  connected,

  /// Not reachable; retrying.
  unreachable,
}

/// The app-wide live connection to X-Plane. Connects while a host is set
/// and live mode is on, and reconnects on its own when X-Plane restarts or
/// the network drops.
class SimController extends ChangeNotifier {
  SimController({
    required this._settings,
    this._connector = connectXPlane,
    this.retryDelay = const Duration(seconds: 5),
  }) {
    _settings.addListener(_onSettings);
    _onSettings();
  }

  final SettingsController _settings;
  final SimConnector _connector;

  final Duration retryDelay;

  SimStatus _status = SimStatus.off;
  SimSession? _session;
  StreamSubscription<SimSnapshot>? _subscription;
  Timer? _retry;
  String? _target;
  SimSnapshot? _snapshot;
  DateTime _lastNotify = DateTime(0);
  var _generation = 0;
  bool _disposed = false;

  final _snapshots = StreamController<SimSnapshot>.broadcast();

  SimStatus get status => _status;
  bool get isConnected => _status == SimStatus.connected;
  String? get version => _session?.version;

  /// Latest values while connected.
  SimSnapshot? get snapshot => isConnected ? _snapshot : null;

  /// Every snapshot (10 Hz); listeners get no rebuild throttling.
  Stream<SimSnapshot> get snapshots => _snapshots.stream;

  void _onSettings() {
    final host = _settings.simHost;
    final target = _settings.simLive && host.isNotEmpty
        ? '$host:${_settings.simPort}'
        : null;
    if (target == _target) return;
    _target = target;
    _restart();
  }

  Future<void> _restart() async {
    final generation = ++_generation;
    _retry?.cancel();
    await _drop();
    if (_target == null) {
      _set(SimStatus.off);
      return;
    }
    await _connect(generation);
  }

  Future<void> _drop() async {
    await _subscription?.cancel();
    _subscription = null;
    final s = _session;
    _session = null;
    _snapshot = null;
    await s?.close();
  }

  Future<void> _connect(int generation) async {
    if (_disposed || generation != _generation) return;
    if (_status != SimStatus.waitingForFlight) _set(SimStatus.connecting);
    final SimSession session;
    try {
      session = await _connector(_settings.simHost, _settings.simPort);
    } on Object catch (e) {
      if (_disposed || generation != _generation) return;
      _set(
        e is XPlaneException && e.message == 'noFlight'
            ? SimStatus.waitingForFlight
            : SimStatus.unreachable,
      );
      _retry = Timer(retryDelay, () => _connect(generation));
      return;
    }
    if (_disposed || generation != _generation) {
      await session.close();
      return;
    }
    _session = session;
    _subscription = session.snapshots.listen(_onSnapshot);
    _set(SimStatus.connected);
    session.done.then((_) async {
      if (_disposed || generation != _generation || _session != session) {
        return;
      }
      await _drop();
      _set(SimStatus.connecting);
      _retry = Timer(retryDelay, () => _connect(generation));
    });
  }

  void _onSnapshot(SimSnapshot s) {
    _snapshot = s;
    _snapshots.add(s);
    // Widgets don't need 10 Hz.
    final now = DateTime.now();
    if (now.difference(_lastNotify).inMilliseconds >= 250) {
      _lastNotify = now;
      notifyListeners();
    }
  }

  void _set(SimStatus s) {
    if (_status == s) return;
    _status = s;
    notifyListeners();
  }

  /// Tunes [radio]; `false` when not connected.
  bool tune(SimRadio radio, int khz, {required bool standby}) =>
      _session?.tune(radio, khz, standby: standby) ?? false;

  bool swap(SimRadio radio) => _session?.swap(radio) ?? false;

  /// Try again now instead of waiting for the next retry.
  void reconnect() {
    if (_target != null && !isConnected) _restart();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _retry?.cancel();
    _settings.removeListener(_onSettings);
    _drop();
    _snapshots.close();
    super.dispose();
  }
}
