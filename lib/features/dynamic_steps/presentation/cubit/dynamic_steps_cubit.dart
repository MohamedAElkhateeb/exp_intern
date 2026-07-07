import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/base_model.dart';
import '../../../../core/utils/endpoint_manger.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../data/model/dynamic_step_model.dart';
import '../../domain/entity/dynamic_step_entity.dart';
import '../../domain/repositories/steps_repository.dart';
import 'dynamic_steps_state.dart';

@injectable
class DynamicStepsCubit extends Cubit<DynamicStepsState> {
  final DynamicStepsRepository _firstStepRepository;
  final ApiService _apiService;

  DynamicStepsCubit(this._firstStepRepository, this._apiService)
      : super(const DynamicStepsState());

  Future<void> fetchFirstStep({required int serviceType,required String serviceId}) async {
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _firstStepRepository.getFirstStep(
      serviceType: serviceType,
      serviceId: serviceId,

    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        failure: failure,
      )),
          (firstStepEntity) => emit(state.copyWith(
        status: RequestStatus.success,
            stepEntity: firstStepEntity,
      )),
    );
  }

  Future<void> executeDynamicStep({
    required String controller,
    required String action,
    required String method,
    Map<String, dynamic>? queryParameters,
  }) async {
    emit(state.copyWith(
      submitStatus: RequestStatus.loading,
      stepEntity: null,
    ));

    try {
      final String path = EndpointsManager.generateDynamicPath(
        controller: controller,
        action: action,
      );

      final response = await _apiService.executeDynamicStep(
        path: path,
        method: method,
        queryParameters: queryParameters,
      );

      final responseModel = BaseResponse<DynamicStepModel>.fromJson(
        response.data,
            (json) => DynamicStepModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseModel.status == 200 && responseModel.data != null) {
        final DynamicStepEntity? nextActionName = responseModel.data;

        emit(state.copyWith(
          submitStatus: RequestStatus.success,
          stepEntity: nextActionName,
        ));
      } else {
        emit(state.copyWith(
          submitStatus: RequestStatus.error,
          failure: ServerFailure(
            message: responseModel.message ?? "فشل في إتمام الخطوة الديناميكية",
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        submitStatus: RequestStatus.error,
        failure: ServerFailure(message: "حدث خطأ غير متوقع"),
      ));
    }
  }

  void resetState() {
    emit(const DynamicStepsState());
  }

  void resetSubmitStatus() {
    emit(state.copyWith(
      submitStatus: RequestStatus.initial,
      stepEntity: null,
    ));
  }
}