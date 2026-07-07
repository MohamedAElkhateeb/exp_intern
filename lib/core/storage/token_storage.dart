// core/storage/token_storage.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
@LazySingleton()
class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _crmUserIdKey = 'crm_user_id';



  String? _accessToken;
  String? _crmUserId;

  Future<void> saveTokens({
    required String accessToken,
    String? crmUserId,
  }) async {
    _accessToken = accessToken;
    _crmUserId = crmUserId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);

    if (crmUserId != null) {
      await prefs.setString(_crmUserIdKey, crmUserId);
    }
  }

  Future<String?> getCrmUserId() async {
    if (_crmUserId != null) return _crmUserId;

    final prefs = await SharedPreferences.getInstance();
    _crmUserId = prefs.getString(_crmUserIdKey);
    return _crmUserId;
  }

  Future<String?> getAccessToken() async {
    if (_accessToken != null) return _accessToken;

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    return _accessToken;
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _crmUserId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_crmUserIdKey); // 🌟 مسح الـ ID
  }
}