import 'package:exp_intern/core/utils/request_status_enum.dart';

extension RequestStatusX on RequestStatus {
  bool get isLoading => this == RequestStatus.loading;
  bool get isSuccess => this == RequestStatus.success;
  bool get isError => this == RequestStatus.error;
  bool get isInitial => this == RequestStatus.initial;
}