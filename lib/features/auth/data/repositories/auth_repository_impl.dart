import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/storage/token_storage.dart';
import 'package:exp_intern/core/utils/locale_keys.g.dart';
import 'package:exp_intern/features/auth/domain/entities/user_entity.dart';
import 'package:exp_intern/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/base_model.dart';
import '../data_source/auth_remote_data_source.dart';
import '../model/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        userName: userName,
        password: password,
        rememberMe: rememberMe,
        autoFillCode: autoFillCode,
      );

      final responseModel = BaseResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseModel.data != null) {
        final userModel = responseModel.data!;

        if (userModel.accessToken != null &&
            userModel.accessToken!.isNotEmpty) {
          await _tokenStorage.saveTokens(
            accessToken: userModel.accessToken!,
            crmUserId: userModel.crmUserId,
          );
        }

        return Right(userModel);
      } else {
        return Left(
          ServerFailure(
            message: responseModel.message ?? LocaleKeys.data_error.tr(),
          ),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
