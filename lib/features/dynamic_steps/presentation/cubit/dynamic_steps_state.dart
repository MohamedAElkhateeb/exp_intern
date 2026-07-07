import '../../../../core/errors/failures.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/entity/dynamic_step_entity.dart';

class DynamicStepsState {
  final RequestStatus status;
  final RequestStatus submitStatus;
  final DynamicStepEntity? stepEntity;
  final Failure? failure;

  const DynamicStepsState({
    this.status = RequestStatus.initial,
    this.submitStatus = RequestStatus.initial,
    this.stepEntity,
    this.failure,
  });

  bool get isInitial => status == RequestStatus.initial;
  bool get isLoading => status == RequestStatus.loading;
  bool get isSuccess => status == RequestStatus.success;
  bool get isError => status == RequestStatus.error;

  bool get isSubmitInitial => submitStatus == RequestStatus.initial;
  bool get isSubmitLoading => submitStatus == RequestStatus.loading;
  bool get isSubmitSuccess => submitStatus == RequestStatus.success;
  bool get isSubmitError => submitStatus == RequestStatus.error;

  DynamicStepsState copyWith({
    RequestStatus? status,
    RequestStatus? submitStatus,
    DynamicStepEntity? stepEntity,
    Failure? failure,
  }) {
    return DynamicStepsState(
      status: status ?? this.status,
      submitStatus: submitStatus ?? this.submitStatus,
      stepEntity: stepEntity ?? this.stepEntity,
      failure: failure ?? this.failure,
    );
  }
}