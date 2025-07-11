class Env {
  static late final String baseUrl;
  static late final String clientId;
  static late final String clientSecret;

  static void init({required Map<String, String> env}) {
    baseUrl = env['BASE_URL'] ?? '';
    clientId = env['CLIENT_ID'] ?? '';
    clientSecret = env['CLIENT_SECRET'] ?? '';
    
    _validate();
  }

  static void _validate() {
    if (baseUrl.isEmpty || clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Missing required environment variables');
    }
  }
}