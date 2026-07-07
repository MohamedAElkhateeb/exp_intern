import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/base_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../data_source/addresses_remote_data_source.dart';
import '../model/address_model.dart';

@LazySingleton(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource _remoteDataSource;

  AddressesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AddressEntity>> getSavedAddresses({required String contactId,String? serviceId,}) async {
    try {
      final response = await _remoteDataSource.getSavedAddresses(contactId: contactId,serviceId: serviceId);
      final responseModel = BaseResponse<AddressModel>.fromJson(
        response.data,
            (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseModel.status == 200 && responseModel.data != null) {
        return Right(responseModel.data!);
      } else {
        return Left(ServerFailure(message: responseModel.message ?? "فشل جلب العناوين"));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}