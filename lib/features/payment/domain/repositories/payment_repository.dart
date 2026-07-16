import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/entity.dart';
abstract class PaymentRepository {
  Future<Either<Failure, ShopperResultEntity>> getShopperResult({
    required String id,
    required int type,
  });
  Future<Either<Failure, String>> getCheckOutId({
    required String id,
    required int type,
    required String cardBrand,
  });
}
