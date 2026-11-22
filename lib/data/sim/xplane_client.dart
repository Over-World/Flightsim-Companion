import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class XPlaneInfo {
  const XPlaneInfo({required this.version, required this.apiVersions});

  /// e.g. `12.1.4`, `null` when X-Plane didn't report it.
  final String? version;
  final List<String> apiVersions;
}

class XPlaneException implements Exception {
  const XPlaneException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Client for the X-Plane 12 web API (REST + WebSocket) on the local network.
class XPlaneClient {
  XPlaneClient({required this.host, required this.port, http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final String host;
  final int port;
  final http.Client _client;
  final bool _ownsClient;

  Uri _uri(String path) =>
      Uri(scheme: 'http', host: host, port: port, path: path);

  /// Checks that the web API is reachable and reports its versions.
  Future<XPlaneInfo> capabilities({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final http.Response response;
    try {
      response = await _client.get(_uri('/api/capabilities')).timeout(timeout);
    } on TimeoutException {
      throw const XPlaneException('timeout');
    } on http.ClientException catch (e) {
      throw XPlaneException(e.message);
    }
    if (response.statusCode != 200) {
      throw XPlaneException('HTTP ${response.statusCode}');
    }
    final json = jsonDecode(response.body);
    if (json is! Map) throw const XPlaneException('unexpected response');
    final api = json['api'];
    final xplane = json['x-plane'];
    return XPlaneInfo(
      version: xplane is Map ? xplane['version']?.toString() : null,
      apiVersions: api is Map && api['versions'] is List
          ? [for (final v in api['versions'] as List) '$v']
          : const [],
    );
  }

  /// Versioned API path, e.g. `/api/v2`. X-Plane 12.1.1–12.1.3 has no
  /// capabilities endpoint and only speaks v1.
  Future<String> apiBase() async {
    try {
      final info = await capabilities();
      for (final v in const ['v3', 'v2', 'v1']) {
        if (info.apiVersions.contains(v)) return '/api/$v';
      }
      return '/api/v1';
    } on XPlaneException catch (e) {
      if (e.message == 'HTTP 404') return '/api/v1';
      rethrow;
    }
  }

  /// Session ids of the named datarefs. Names that don't exist (e.g.
  /// aircraft-specific ones) are left out. Empty until a flight is loaded.
  Future<Map<String, int>> resolveDatarefs(
    String base,
    List<String> names, {
    Duration timeout = const Duration(seconds: 6),
  }) async {
    Future<http.Response> query(List<String> batch) => _client
        .get(
          Uri(
            scheme: 'http',
            host: host,
            port: port,
            path: '$base/datarefs',
            query: [
              for (final n in batch)
                'filter[name]=${Uri.encodeQueryComponent(n)}',
              'fields=id,name',
            ].join('&'),
          ),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(timeout);

    Map<String, int> parse(http.Response r) {
      final json = jsonDecode(r.body);
      final data = json is Map ? json['data'] : null;
      return {
        if (data is List)
          for (final d in data)
            if (d is Map && d['name'] is String && d['id'] is int)
              d['name'] as String: d['id'] as int,
      };
    }

    try {
      final all = await query(names);
      if (all.statusCode == 200) return parse(all);
      if (all.statusCode != 404) {
        throw XPlaneException('HTTP ${all.statusCode}');
      }
      // One unknown name fails the whole batch: ask one by one.
      final result = <String, int>{};
      final singles = await Future.wait([
        for (final n in names) query([n]),
      ]);
      for (final r in singles) {
        if (r.statusCode == 200) result.addAll(parse(r));
      }
      return result;
    } on TimeoutException {
      throw const XPlaneException('timeout');
    } on http.ClientException catch (e) {
      throw XPlaneException(e.message);
    }
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
