/// External services that need app-owned credentials.
enum AppService { openAip, chartFox }

/// Where and how to reach a service with the app's credentials.
class ServiceEndpoint {
  const ServiceEndpoint({required this.baseUri, this.headers = const {}});

  final Uri baseUri;
  final Map<String, String> headers;
}

/// Single access point for app-owned API keys.
///
/// Users never enter keys. Private builds read them from `--dart-define`
/// ([BuildTimeCredentials]); a public release swaps in a proxy-backed
/// implementation without touching any feature code.
abstract interface class ServiceCredentials {
  /// `null` when the service is not configured in this build: the feature
  /// must then be disabled with a hint.
  ServiceEndpoint? endpoint(AppService service);

  /// OAuth client id (public, PKCE) for services the user logs into.
  String? oauthClientId(AppService service);

  bool isAvailable(AppService service);
}

class BuildTimeCredentials implements ServiceCredentials {
  const BuildTimeCredentials();

  static const _openAipKey = String.fromEnvironment('OPENAIP_API_KEY');
  static const _chartFoxClientId = String.fromEnvironment('CHARTFOX_CLIENT_ID');

  @override
  ServiceEndpoint? endpoint(AppService service) => switch (service) {
    AppService.openAip when _openAipKey.isNotEmpty => ServiceEndpoint(
      baseUri: Uri.parse('https://api.core.openaip.net/api'),
      headers: const {'x-openaip-api-key': _openAipKey},
    ),
    AppService.chartFox when _chartFoxClientId.isNotEmpty => ServiceEndpoint(
      baseUri: Uri.parse('https://api.chartfox.org'),
    ),
    _ => null,
  };

  @override
  String? oauthClientId(AppService service) => switch (service) {
    AppService.chartFox when _chartFoxClientId.isNotEmpty => _chartFoxClientId,
    _ => null,
  };

  @override
  bool isAvailable(AppService service) => endpoint(service) != null;
}
