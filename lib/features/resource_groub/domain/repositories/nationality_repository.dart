import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/nationality_entity.dart';

abstract class NationalityRepository {
  Future<Either<Failure, List<NationalityEntity>>> getNationalities({
    required String serviceId,
  });
}
