
abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  });

  Future<void> logout();
}