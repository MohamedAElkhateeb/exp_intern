import '../../../../core/utils/request_status_enum.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/address_entity.dart';

class AddressesState {
  final RequestStatus addressesStatus;
  final AddressEntity? addressEntity;
  final Failure? failure;

  const AddressesState({
    this.addressesStatus = RequestStatus.initial,
    this.addressEntity,
    this.failure,
  });

  bool get isAddressesInitial => addressesStatus == RequestStatus.initial;
  bool get isAddressesLoading => addressesStatus == RequestStatus.loading;
  bool get isAddressesSuccess => addressesStatus == RequestStatus.success;
  bool get isAddressesError => addressesStatus == RequestStatus.error;

  AddressesState copyWith({
    RequestStatus? addressesStatus,
    AddressEntity? addressEntity,
    Failure? failure,
  }) {
    return AddressesState(
      addressesStatus: addressesStatus ?? this.addressesStatus,
      addressEntity: addressEntity ?? this.addressEntity,
      failure: failure ?? this.failure,
    );
  }
}