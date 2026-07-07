import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/dynamic_step_entity.dart';

abstract class DynamicStepsRepository {
  Future<Either<Failure, DynamicStepEntity>> getFirstStep({required int serviceType, required String serviceId});
}