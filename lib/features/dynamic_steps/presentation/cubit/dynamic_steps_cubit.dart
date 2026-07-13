import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/base_model.dart';
import '../../../../core/utils/endpoint_manager.dart';
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
    Map<String, dynamic>? data,
  }) async {
    emit(state.copyWith(
      submitStatus: RequestStatus.loading,
      stepEntity: null,
    ));

    // 🟢 طباعة البيانات المدخلة للدالة قبل بدء الطلب
    print("================ 🚀 [CUBIT - executeDynamicStep] START ================");
    print("🔹 Controller: $controller");
    print("🔹 Action: $action");
    print("🔹 Method: $method");
    print("🔹 QueryParameters: $queryParameters");
    print("🔹 Data (Body): $data");

    try {
      final String path = EndpointsManager.generateDynamicPath(
        controller: controller,
        action: action,
      );
      print("🎯 Generated Path: $path");

      print("⏳ Sending Request via ApiService...");
      final response = await _apiService.executeDynamicStep(
        path: path,
        method: method,
        queryParameters: queryParameters,
        data: data,
      );

      print("✅ Response Received! StatusCode: ${response.statusCode}");
      print("📄 Response Raw Data: ${response.data}");

      print("🧩 Starting JSON Parsing into BaseResponse...");
      final responseModel = BaseResponse<DynamicStepModel>.fromJson(
        response.data,
            (json) => DynamicStepModel.fromJson(json as Map<String, dynamic>),
      );

      print("📊 Parsed Response Status: ${responseModel.status}");
      print("📊 Parsed Response Message: ${responseModel.message}");

      if (responseModel.status == 200 && responseModel.data != null) {
        final DynamicStepEntity? nextActionName = responseModel.data;
        print("🎉 Success! Next Step Name: ${nextActionName?.name}");

        emit(state.copyWith(
          submitStatus: RequestStatus.success,
          stepEntity: nextActionName,
        ));
      } else {
        print("⚠️ Server custom status error (Not 200 or Data is Null)");
        emit(state.copyWith(
          submitStatus: RequestStatus.error,
          failure: ServerFailure(
            message: responseModel.message ?? "فشل في إتمام الخطوة الديناميكية",
          ),
        ));
      }
    } catch (e, stackTrace) {
      // 🔴 طباعة تفاصيل الخطأ في حال حدوث الـ Exception
      print("❌❌❌ [CUBIT ERROR] Exception caught in executeDynamicStep ❌❌❌");
      print("🚨 Error details: $e");
      print("🐾 StackTrace: $stackTrace");

      emit(state.copyWith(
        submitStatus: RequestStatus.error,
        failure: ServerFailure(message: "حدث خطأ غير متوقع"),
      ));
    } finally {
      print("================ 🏁 [CUBIT - executeDynamicStep] END ================");
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
  Future<void> fetchStepDetailsByActionName({
    required String stepId,
    required String actionName,
    required int serviceType,
  }) async {
    emit(state.copyWith(
      stepDetailsStatus: RequestStatus.loading,
    ));

    final result = await _firstStepRepository.getStepDetailsByActionName(
      stepId: stepId,
      actionName: actionName,
      serviceType: serviceType,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        stepDetailsStatus: RequestStatus.error,
        stepDetailsFailure: failure,
      )),
          (stepDetails) => emit(state.copyWith(
        stepDetailsStatus: RequestStatus.success,
        stepDetailsEntity: stepDetails,
      )),
    );
  }
}