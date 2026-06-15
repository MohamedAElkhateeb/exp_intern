import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  }) async {
    return await _repository.login(
      userName: userName,
      password: password,
      rememberMe: rememberMe,
      autoFillCode: autoFillCode,
    );
  }
}