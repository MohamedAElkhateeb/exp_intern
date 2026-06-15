import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  String? _accessToken;

  // حفظ التوكن
  Future<void> saveTokens(String accessToken,) async {
    _accessToken = accessToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  // جلب التوكن المحفوظ
  Future<String?> getAccessToken() async {
    if (_accessToken != null) return _accessToken;

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    return _accessToken;
  }


  // مسح التوكن (لوج آوت)
  Future<void> clearTokens() async {
    _accessToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}