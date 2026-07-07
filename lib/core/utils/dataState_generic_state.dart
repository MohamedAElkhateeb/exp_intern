import 'package:exp_intern/core/utils/request_status_enum.dart';

class DataState<T> {
  final RequestStatus status;
  final List<T> data;
  final String? error;

  const DataState({
    this.status = RequestStatus.initial,
    this.data = const [],
    this.error,
  });

  DataState<T> copyWith({
    RequestStatus? status,
    List<T>? data,
    String? error,
  }) {
    return DataState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}