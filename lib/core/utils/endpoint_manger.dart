class EndpointsManager {
  static const String baseUrl = 'https://mueen-apitest.azurewebsites.net';
  static String get locale {
    return 'ar';
  }
  static String _getLocalizedPath(String path) {
    return '/$locale$path';
  }
  static String get login => _getLocalizedPath('/api/Account/Login');
}
