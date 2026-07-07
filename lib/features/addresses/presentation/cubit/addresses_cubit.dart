import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/repositories/addresses_repository.dart';
import 'addresses_state.dart';

@injectable
class AddressesCubit extends Cubit<AddressesState> {
  final AddressesRepository _addressesRepository;
  final TokenStorage _tokenStorage;

  AddressesCubit(this._addressesRepository, this._tokenStorage)
      : super(const AddressesState());

  Future<void> fetchSavedAddresses({String? serviceId}) async {
    emit(state.copyWith(addressesStatus: RequestStatus.loading));

    try {
      final contactId = await _tokenStorage.getCrmUserId();

      if (contactId == null || contactId.isEmpty) {
        emit(state.copyWith(
          addressesStatus: RequestStatus.error,
          failure: ServerFailure(message: "لم يتم العثور على معرف المستخدم"),
        ));
        return;
      }

      final result = await _addressesRepository.getSavedAddresses(
        contactId: contactId,
        serviceId: serviceId,
      );

      result.fold(
            (failure) => emit(state.copyWith(
          addressesStatus: RequestStatus.error,
          failure: failure,
        )),
            (addressEntity) => emit(state.copyWith(
          addressesStatus: RequestStatus.success,
          addressEntity: addressEntity,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        addressesStatus: RequestStatus.error,
        failure: ServerFailure(message: "حدث خطأ غير متوقع"),
      ));
    }
  }
}