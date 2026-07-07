
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity userEntity;
  AuthSuccess(this.userEntity);
}

class AuthFailure extends AuthState {
  final Failure failure;
  AuthFailure(this.failure);
  String get errorMessage => failure.message ?? '';
}