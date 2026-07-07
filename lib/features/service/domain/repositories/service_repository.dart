import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> fetchServices({required int serviceType});
}