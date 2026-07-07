import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/address_entity.dart';

abstract class AddressesRepository {
  Future<Either<Failure, AddressEntity>> getSavedAddresses({required String contactId,String? serviceId});
}