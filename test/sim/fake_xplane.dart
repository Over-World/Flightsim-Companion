import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A tiny X-Plane web API on localhost: capabilities, dataref lookup by
/// name (404 when any name is unknown, like X-Plane), and a WebSocket with
/// subscribe / update / set.
class FakeXPlane {
  FakeXPlane._(this._server, this.values);

  static Future<FakeXPlane> start(Map<String, Object?> values) =>
      startOn(0, values);

  static Future<FakeXPlane> startOn(
    int port,
    Map<String, Object?> values,
  ) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    final fake = FakeXPlane._(server, values);
    server.listen(fake._handle);
    return fake;
  }

  final HttpServer _server;

  /// Current dataref values by name; names missing here don't exist.
  final Map<String, Object?> values;

  /// Every `dataref_set_values` entry received, as (name, value).
  final List<(String, Object?)> writes = [];

  final _sockets = <WebSocket>[];
  final _subscribed = <WebSocket, Set<int>>{};
  late final List<String> _names = values.keys.toList();

  int get port => _server.port;

  int _id(String name) => 1000 + _names.indexOf(name);
  String? _name(int id) {
    final i = id - 1000;
    return i >= 0 && i < _names.length ? _names[i] : null;
  }

  Future<void> _handle(HttpRequest req) async {
    final path = req.uri.path;
    if (path == '/api/v2' && WebSocketTransformer.isUpgradeRequest(req)) {
      final ws = await WebSocketTransformer.upgrade(req);
      _sockets.add(ws);
      ws.listen((m) => _onMessage(ws, m as String));
      return;
    }
    final res = req.response..headers.contentType = ContentType.json;
    if (path == '/api/capabilities') {
      res.write(
        jsonEncode({
          'api': {
            'versions': ['v1', 'v2'],
          },
          'x-plane': {'version': '12.1.4'},
        }),
      );
    } else if (path == '/api/v2/datarefs') {
      final wanted = [
        for (final p in req.uri.query.split('&').map(Uri.decodeQueryComponent))
          if (p.startsWith('filter[name]='))
            p.substring('filter[name]='.length),
      ];
      if (wanted.any((n) => !values.containsKey(n))) {
        res.statusCode = 404;
        res.write(jsonEncode({'error_code': 'invalid_dataref_name'}));
      } else {
        res.write(
          jsonEncode({
            'data': [
              for (final n in wanted) {'id': _id(n), 'name': n},
            ],
          }),
        );
      }
    } else {
      res.statusCode = 404;
    }
    await res.close();
  }

  void _onMessage(WebSocket ws, String message) {
    final json = jsonDecode(message) as Map;
    final params = json['params'] as Map;
    ws.add(
      jsonEncode({'req_id': json['req_id'], 'type': 'result', 'success': true}),
    );
    switch (json['type']) {
      case 'dataref_subscribe_values':
        _subscribed[ws] = {
          for (final d in params['datarefs'] as List) (d as Map)['id'] as int,
        };
        push();
      case 'dataref_set_values':
        for (final d in params['datarefs'] as List) {
          final name = _name((d as Map)['id'] as int)!;
          writes.add((name, d['value']));
          values[name] = d['value'];
        }
        push();
    }
  }

  /// Sends all subscribed values to every client.
  void push() {
    for (final MapEntry(key: ws, value: ids) in _subscribed.entries) {
      ws.add(
        jsonEncode({
          'type': 'dataref_update_values',
          'data': {for (final id in ids) '$id': values[_name(id)]},
        }),
      );
    }
  }

  /// Drops every WebSocket, like X-Plane quitting.
  Future<void> dropClients() async {
    for (final ws in _sockets) {
      await ws.close();
    }
    _sockets.clear();
    _subscribed.clear();
  }

  Future<void> stop() async {
    await dropClients();
    await _server.close(force: true);
  }
}

/// Values for a C172 parked at Egelsbach with radios tuned.
Map<String, Object?> parkedAtEgelsbach() => {
  'sim/flightmodel/position/latitude': 49.9608,
  'sim/flightmodel/position/longitude': 8.6436,
  'sim/flightmodel/position/elevation': 117.0,
  'sim/flightmodel/position/y_agl': 0.5,
  'sim/flightmodel/position/groundspeed': 0.0,
  'sim/flightmodel/position/hpath': 270.0,
  'sim/flightmodel/position/true_psi': 268.0,
  'sim/flightmodel/position/mag_psi': 264.0,
  'sim/flightmodel/position/indicated_airspeed': 0.0,
  'sim/flightmodel/position/vh_ind_fpm': 0.0,
  'sim/flightmodel/forces/g_nrml': 1.0,
  'sim/flightmodel/failures/onground_any': 1,
  'sim/time/paused': 0,
  'sim/flightmodel/weight/m_fuel_total': 120.0,
  'sim/flightmodel/engine/ENGN_running': [1, 0, 0, 0, 0, 0, 0, 0],
  'sim/cockpit2/controls/parking_brake_ratio': 1.0,
  'sim/aircraft/view/acf_ICAO': base64.encode([...ascii.encode('C172'), 0, 0]),
  'sim/cockpit2/radios/actuators/com1_frequency_hz_833': 119150,
  'sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833': 121730,
  'sim/cockpit2/radios/actuators/com2_frequency_hz_833': 118405,
  'sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833': 121500,
  'sim/cockpit2/radios/actuators/nav1_frequency_hz': 11420,
  'sim/cockpit2/radios/actuators/nav1_standby_frequency_hz': 11590,
  'sim/cockpit2/radios/actuators/nav2_frequency_hz': 10800,
  'sim/cockpit2/radios/actuators/nav2_standby_frequency_hz': 10800,
  'sim/cockpit2/radios/actuators/adf1_frequency_hz': 386,
  'sim/cockpit2/radios/actuators/adf1_standby_frequency_hz': 400,
};
