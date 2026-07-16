import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/base_model.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../domain/entities/entity.dart';
import '../datasource/payment_remote_data_source.dart';
import '../model/shopper_result_model.dart';
import '../../domain/repositories/payment_repository.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ShopperResultEntity>> getShopperResult({
    required String id,
    required int type,
  }) async {
    try {
      final response = await _remoteDataSource.getShopperResult(
        id: id,
        type: type,
      );

      final responseModel = BaseResponse<ShopperResultModel>.fromJson(
        response.data,
            (json) => ShopperResultModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseModel.status == 200 && responseModel.data != null) {
        return Right(responseModel.data!);
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
  Future<Either<Failure, String>> getCheckOutId({
    required String id,
    required int type,
    required String cardBrand,
  }) async {
    try {
      final response = await _remoteDataSource.getCheckOutId(
        id: id,
        type: type,
        cardBrand: cardBrand,
      );

      final responseModel = BaseResponse<String>.fromJson(
        response.data,
            (json) => json as String,
      );

      if (responseModel.status == 200 && responseModel.data != null) {
        return Right(responseModel.data!);
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
}