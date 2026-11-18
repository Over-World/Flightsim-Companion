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
    : _client = client ?? http.Client();

  final String host;
  final int port;
  final http.Client _client;

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
}
