import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/base_model.dart';
import '../../../../core/utils/endpoint_manager.dart';
import '../model/available_day_with_date_model.dart';
import '../model/available_days_params.dart';
import '../model/contract_duration_model.dart';
import '../model/contract_success_model.dart';
import '../model/hourly_packages_result_model.dart';
import '../model/hourly_pricing_response_model.dart';
import '../model/num_of_visits_model.dart';
import '../model/shift_hours_model.dart';
import '../model/shift_model.dart';
import '../model/time_slot_model.dart';
import '../model/time_slot_param.dart';
import '../model/worker_count_model.dart';

@lazySingleton
class HourlyContractRemoteDataSource {
  final ApiService _apiService;

  HourlyContractRemoteDataSource(this._apiService);

  Future<BaseResponse<List<ShiftModel>>> getShifts({
    required String serviceId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.shifts,
      queryParameters: {'serviceId': serviceId},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) => (jsonT as List).map((e) => ShiftModel.fromJson(e)).toList(),
    );
  }

  Future<BaseResponse<List<ContractDurationModel>>> getContractDurations({
    required String serviceId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.contractDurations,
      queryParameters: {'serviceId': serviceId},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) => (jsonT as List)
          .map((e) => ContractDurationModel.fromJson(e))
          .toList(),
    );
  }

  Future<BaseResponse<List<NumOfVisitsModel>>> getNumOfVisits({
    required String serviceId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.numOfVisits,
      queryParameters: {'serviceId': serviceId},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) =>
          (jsonT as List).map((e) => NumOfVisitsModel.fromJson(e)).toList(),
    );
  }

  Future<BaseResponse<List<WorkerCountModel>>> getWorkerCounts({
    required String serviceId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.numOfWorkers,
      queryParameters: {'serviceId': serviceId},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) =>
          (jsonT as List).map((e) => WorkerCountModel.fromJson(e)).toList(),
    );
  }

  Future<BaseResponse<List<TimeSlotModel>>> getTimeSlots({
    required TimeSlotParams params,
  }) async {
    final response = await _apiService.postData(
      path: EndpointsManager.getTimeSlotByServiceIdForDD,
      data: params.toJson(),
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) => (jsonT as List).map((e) => TimeSlotModel.fromJson(e)).toList(),
    );
  }

  Future<BaseResponse<List<ShiftHoursModel>>> getShiftHours({
    required String serviceId,
    required int shift,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.shiftHours,
      queryParameters: {'serviceId': serviceId, 'shift': shift},
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) =>
          (jsonT as List).map((e) => ShiftHoursModel.fromJson(e)).toList(),
    );
  }

  Future<BaseResponse<String>> getArrivalTime({
    required String timeSlotId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.getArrivalTime,
      queryParameters: {'timeSlotId': timeSlotId},
    );

    return BaseResponse.fromJson(response.data, (jsonT) => jsonT as String);
  }

  Future<BaseResponse<List<AvailableDayWithDateModel>>> getContractDates({
    required AvailableDaysParams params,
    required String stepId,
  }) async {
    final response = await _apiService.postData(
      path: EndpointsManager.availableDaysWithDate,
      queryParameters: {'stepId': stepId},
      data: params.toJson(),
    );

    return BaseResponse.fromJson(
      response.data,
      (jsonT) => (jsonT as List)
          .map((e) => AvailableDayWithDateModel.fromJson(e))
          .toList(),
    );
  }
  Future<BaseResponse<HourlyPackagesResultModel>> getFixedPackages({
    required String stepId,
    required String nationalityId,
    required int shift,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.fixedPackages,
      queryParameters: {
        'stepId': stepId,
        'nationalityId': nationalityId,
        'shift': shift,
      },
    );
    return BaseResponse.fromJson(
      response.data,
          (jsonT) => HourlyPackagesResultModel.fromJson(jsonT as Map<String, dynamic>),
    );
  }
  Future<BaseResponse<HourlyPricingResponseModel>> getHourlyPricing({
    required String stepId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiService.postData(
      path: EndpointsManager.hourlyPricing,
      queryParameters: {'stepId': stepId},
      data: data,
    );

    return BaseResponse.fromJson(
      response.data,
          (jsonT) => HourlyPricingResponseModel.fromJson(jsonT as Map<String, dynamic>),
    );
  }
  Future<BaseResponse<ContractSuccessModel>> getContractSuccessData({
    required String stepId,
  }) async {
    final response = await _apiService.getData(
      path: EndpointsManager.contractSuccessData,
      queryParameters: {'stepId': stepId},
    );

    return BaseResponse.fromJson(
      response.data,
          (jsonT) => ContractSuccessModel.fromJson(jsonT as Map<String, dynamic>),
    );
  }
}
