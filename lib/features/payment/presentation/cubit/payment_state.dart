import '../../../../core/errors/failures.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/entities/entity.dart';

class PaymentState {
  final RequestStatus shopperResultStatus;
  final ShopperResultEntity? shopperResultEntity;
  final Failure? shopperResultFailure;
  final RequestStatus checkOutStatus;
  final String? checkOutId;
  final Failure? checkOutFailure;

  const PaymentState({
    this.shopperResultStatus = RequestStatus.initial,
    this.shopperResultEntity,
    this.shopperResultFailure,
    this.checkOutStatus = RequestStatus.initial,
    this.checkOutId,
    this.checkOutFailure,
  });

  bool get isShopperResultInitial => shopperResultStatus == RequestStatus.initial;
  bool get isShopperResultLoading => shopperResultStatus == RequestStatus.loading;
  bool get isShopperResultSuccess => shopperResultStatus == RequestStatus.success;
  bool get isShopperResultError => shopperResultStatus == RequestStatus.error;
  bool get isCheckOutInitial => checkOutStatus == RequestStatus.initial;
  bool get isCheckOutLoading => checkOutStatus == RequestStatus.loading;
  bool get isCheckOutSuccess => checkOutStatus == RequestStatus.success;
  bool get isCheckOutError => checkOutStatus == RequestStatus.error;

  PaymentState copyWith({
    RequestStatus? shopperResultStatus,
    ShopperResultEntity? shopperResultEntity,
    Failure? shopperResultFailure,
    RequestStatus? checkOutStatus,
    String? checkOutId,
    Failure? checkOutFailure,
  }) {
    return PaymentState(
      shopperResultStatus: shopperResultStatus ?? this.shopperResultStatus,
      shopperResultEntity: shopperResultEntity ?? this.shopperResultEntity,
      shopperResultFailure: shopperResultFailure ?? this.shopperResultFailure,
      checkOutStatus: checkOutStatus ?? this.checkOutStatus,
      checkOutId: checkOutId ?? this.checkOutId,
      checkOutFailure: checkOutFailure ?? this.checkOutFailure,
    );
  }
}