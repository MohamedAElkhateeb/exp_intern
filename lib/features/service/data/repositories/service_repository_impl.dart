import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_handler.dart'; // تأكد من المسار
import '../../../../core/errors/failures.dart';      // تأكد من المسار
import '../../../../core/utils/base_model.dart';     // تأكد من المسار للـ BaseResponse
import '../../domain/entity/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../data_source/service_remote_data_source.dart';
import '../model/service_model.dart';
@LazySingleton(as: ServiceRepository) // 🔹 إضافة الـ Annotation هنا
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource _remoteDataSource;

  ServiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ServiceEntity>>> fetchServices({required int serviceType}) async {
    try {
      final response = await _remoteDataSource.getServices(serviceType: serviceType);

      final baseResponse = BaseResponse<List<ServiceModel>>.fromJson(
        response.data,
            (json) => (json as List).map((e) => ServiceModel.fromJson(e)).toList(),
      );

      return Right(baseResponse.data ?? []);
    } catch (error) {
      // بنرجع الـ Failure في الـ Left باستخدام الـ ErrorHandler المركزي بتاعك
      return Left(ErrorHandler.handleException(error));
    }
  }
}