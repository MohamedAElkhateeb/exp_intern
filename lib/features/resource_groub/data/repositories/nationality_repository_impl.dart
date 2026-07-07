import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/nationality_entity.dart';
import '../../domain/repositories/nationality_repository.dart';
import '../data_source/nationality_remote_data_source.dart';

@LazySingleton(as: NationalityRepository)
class NationalityRepositoryImpl implements NationalityRepository {
  final NationalityRemoteDataSource _remoteDataSource;

  NationalityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NationalityEntity>>> getNationalities({
    required String serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getNationalities(serviceId: serviceId);
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
