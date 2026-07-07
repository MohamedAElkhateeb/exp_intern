import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/features/dynamic_steps/data/model/dynamic_step_model.dart';
import 'package:injectable/injectable.dart';
import 'package:exp_intern/core/utils/locale_keys.g.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/base_model.dart';
import '../../domain/entity/dynamic_step_entity.dart';
import '../../domain/repositories/steps_repository.dart';
import '../data_source/dynamic_steps_data_source.dart';

@LazySingleton(as: DynamicStepsRepository)
class DynamicStepsRepositoryImpl implements DynamicStepsRepository {
  final DynamicStepsDataSource _remoteDataSource;

  DynamicStepsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DynamicStepEntity>> getFirstStep({required int serviceType,required String serviceId}) async {
    try {
      final response = await _remoteDataSource.getFirstStep(
        serviceType: serviceType,
        serviceId: serviceId,
      );

      final responseModel = BaseResponse<DynamicStepModel>.fromJson(
        response.data,
            (json) => DynamicStepModel.fromJson(json as Map<String, dynamic>),
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