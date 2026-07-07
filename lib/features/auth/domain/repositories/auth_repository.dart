// domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  });

  Future<void> logout();
}