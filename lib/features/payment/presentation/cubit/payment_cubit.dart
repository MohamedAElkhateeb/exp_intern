import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentCubit(this._paymentRepository) : super(const PaymentState());

  Future<void> fetchShopperResult({required String id, required int type}) async {
    emit(state.copyWith(shopperResultStatus: RequestStatus.loading));

    final result = await _paymentRepository.getShopperResult(
      id: id,
      type: type,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        shopperResultStatus: RequestStatus.error,
        shopperResultFailure: failure,
      )),
          (shopperResult) => emit(state.copyWith(
        shopperResultStatus: RequestStatus.success,
        shopperResultEntity: shopperResult,
      )),
    );
  }
  Future<void> generateCheckOutId({
    required String id,
    required int type,
    required String cardBrand,
  }) async {
    emit(state.copyWith(
      checkOutStatus: RequestStatus.loading,
      checkOutFailure: null,
    ));

    final result = await _paymentRepository.getCheckOutId(
      id: id,
      type: type,
      cardBrand: cardBrand,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        checkOutStatus: RequestStatus.error,
        checkOutFailure: failure,
      )),
          (checkOutId) => emit(state.copyWith(
        checkOutStatus: RequestStatus.success,
        checkOutId: checkOutId,
      )),
    );
  }
}