import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> loginUser({
    required String userName,
    required String password,
    bool rememberMe = true,
  }) async {
    emit(AuthLoading());

    final result = await _authRepository.login(
      userName: userName,
      password: password,
      rememberMe: rememberMe,
    );

    result.fold(
          (failure) => emit(AuthFailure(failure)),
          (userEntity) {
        emit(AuthSuccess(userEntity));
      },
    );
  }
}