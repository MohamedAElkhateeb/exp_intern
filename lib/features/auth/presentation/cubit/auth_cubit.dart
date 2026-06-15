import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/use_cases/login_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase) : super(AuthInitial());

  Future<void> loginUser({
    required String userName,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _loginUseCase.call(
      userName: userName,
      password: password,
    );

    if (result['success'] == true) {
      emit(AuthSuccess(result['userEntity']));
    } else {
      emit(AuthFailure(result['message'] ?? 'فشل الاتصال بالسيرفر'));
    }
  }
}