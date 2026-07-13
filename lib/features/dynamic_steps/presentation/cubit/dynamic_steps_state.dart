import '../../../../core/errors/failures.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/entity/dynamic_step_entity.dart';

class DynamicStepsState {
  final RequestStatus status;
  final RequestStatus submitStatus;
  final RequestStatus stepDetailsStatus;
  final DynamicStepEntity? stepEntity;
  final DynamicStepEntity? stepDetailsEntity;
  final Failure? failure;
  final Failure? stepDetailsFailure;

  const DynamicStepsState({
    this.status = RequestStatus.initial,
    this.submitStatus = RequestStatus.initial,
    this.stepDetailsStatus = RequestStatus.initial,
    this.stepEntity,
    this.stepDetailsEntity,
    this.failure,
    this.stepDetailsFailure,
  });

  bool get isInitial => status == RequestStatus.initial;
  bool get isLoading => status == RequestStatus.loading;
  bool get isSuccess => status == RequestStatus.success;
  bool get isError => status == RequestStatus.error;

  bool get isSubmitInitial => submitStatus == RequestStatus.initial;
  bool get isSubmitLoading => submitStatus == RequestStatus.loading;
  bool get isSubmitSuccess => submitStatus == RequestStatus.success;
  bool get isSubmitError => submitStatus == RequestStatus.error;

  bool get isStepDetailsInitial => stepDetailsStatus == RequestStatus.initial;
  bool get isStepDetailsLoading => stepDetailsStatus == RequestStatus.loading;
  bool get isStepDetailsSuccess => stepDetailsStatus == RequestStatus.success;
  bool get isStepDetailsError => stepDetailsStatus == RequestStatus.error;

  DynamicStepsState copyWith({
    RequestStatus? status,
    RequestStatus? submitStatus,
    RequestStatus? stepDetailsStatus,
    DynamicStepEntity? stepEntity,
    DynamicStepEntity? stepDetailsEntity,
    Failure? failure,
    Failure? stepDetailsFailure,
  }) {
    return DynamicStepsState(
      status: status ?? this.status,
      submitStatus: submitStatus ?? this.submitStatus,
      stepDetailsStatus: stepDetailsStatus ?? this.stepDetailsStatus,
      stepEntity: stepEntity ?? this.stepEntity,
      stepDetailsEntity: stepDetailsEntity ?? this.stepDetailsEntity,
      failure: failure ?? this.failure,
      stepDetailsFailure: stepDetailsFailure ?? this.stepDetailsFailure,
    );
  }
}