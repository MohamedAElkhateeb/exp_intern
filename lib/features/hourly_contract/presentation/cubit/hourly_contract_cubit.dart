import 'dart:convert';

import 'package:exp_intern/features/hourly_contract/domain/repositories/hourly_contract_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../data/model/available_days_params.dart';
import '../../data/model/package_property_configModel.dart';
import '../../data/model/time_slot_param.dart';
import '../../domain/entities/package_property_configEntity.dart';
import 'hourly_contract_state.dart';

@injectable
class HourlyContractCubit extends Cubit<HourlyContractState> {
  final HourlyContractRepository _shiftRepo;

  String? _lastRequestKey;

  HourlyContractCubit(this._shiftRepo) : super(const HourlyContractState());

  Future<void> fetchShifts({required String serviceId}) async {
    emit(
      state.copyWith(
        shifts: state.shifts.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getShifts(serviceId: serviceId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            shifts: state.shifts.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (shiftsList) {
        emit(
          state.copyWith(
            shifts: state.shifts.copyWith(
              status: RequestStatus.success,
              data: shiftsList,
            ),
          ),
        );
      },
    );
  }

  Future<void> getShiftHours({
    required String serviceId,
    required int shift,
  }) async {
    emit(
      state.copyWith(
        shiftHours: state.shiftHours.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getShiftHours(
      serviceId: serviceId,
      shift: shift,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            shiftHours: state.shiftHours.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (shiftHoursList) {
        emit(
          state.copyWith(
            shiftHours: state.shiftHours.copyWith(
              status: RequestStatus.success,
              data: shiftHoursList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchContractDurations({required String serviceId}) async {
    emit(
      state.copyWith(
        durations: state.durations.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getContractDurations(serviceId: serviceId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            durations: state.durations.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (durationsList) {
        emit(
          state.copyWith(
            durations: state.durations.copyWith(
              status: RequestStatus.success,
              data: durationsList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNumOfVisits({required String serviceId}) async {
    emit(
      state.copyWith(
        numOfVisits: state.numOfVisits.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getNumOfVisits(serviceId: serviceId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            numOfVisits: state.numOfVisits.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (visitsList) {
        emit(
          state.copyWith(
            numOfVisits: state.numOfVisits.copyWith(
              status: RequestStatus.success,
              data: visitsList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchWorkerCounts({required String serviceId}) async {
    emit(
      state.copyWith(
        workerCounts: state.workerCounts.copyWith(
          status: RequestStatus.loading,
        ),
      ),
    );

    final result = await _shiftRepo.getWorkerCounts(serviceId: serviceId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            workerCounts: state.workerCounts.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (workerCountsList) {
        emit(
          state.copyWith(
            workerCounts: state.workerCounts.copyWith(
              status: RequestStatus.success,
              data: workerCountsList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchTimeSlots({required TimeSlotParams params}) async {
    emit(
      state.copyWith(
        timeSlots: state.timeSlots.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getTimeSlots(params: params);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            timeSlots: state.timeSlots.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (timeSlotsList) {
        emit(
          state.copyWith(
            timeSlots: state.timeSlots.copyWith(
              status: RequestStatus.success,
              data: timeSlotsList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchArrivalTime({required String timeSlotId}) async {
    emit(state.copyWith(arrivalTimeStatus: RequestStatus.loading));

    final result = await _shiftRepo.getArrivalTime(timeSlotId: timeSlotId);

    result.fold(
          (failure) {
        emit(state.copyWith(arrivalTimeStatus: RequestStatus.error));
      },
          (arrivalText) {
        emit(
          state.copyWith(
            arrivalTimeStatus: RequestStatus.success,
            deliveryNotesText: arrivalText,
          ),
        );
      },
    );
  }

  Future<void> fetchAvailableDays({
    required AvailableDaysParams params,
    required String stepId,
  }) async {
    emit(
      state.copyWith(
        availableDays: state.availableDays.copyWith(
          status: RequestStatus.loading,
        ),
      ),
    );

    final result = await _shiftRepo.getContractDates(
      params: params,
      stepId: stepId,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            availableDays: state.availableDays.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (daysList) {
        emit(
          state.copyWith(
            availableDays: state.availableDays.copyWith(
              status: RequestStatus.success,
              data: daysList,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchFixedPackages({
    required String stepId,
    required String nationalityId,
    required int shift,
  }) async {
    emit(
      state.copyWith(
        packages: state.packages.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getFixedPackages(
      stepId: stepId,
      nationalityId: nationalityId,
      shift: shift,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            packages: state.packages.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (packagesResult) {
        Map<String, PackagePropertyConfigEntity> properties = {};

        if (packagesResult.packageProperties is String) {
          try {
            final decoded = jsonDecode(
              packagesResult.packageProperties as String,
            );
            properties = (decoded as Map<String, dynamic>).map((key, value) {
              return MapEntry(key, PackagePropertyConfigModel.fromJson(value));
            });
          } catch (_) {}
        } else {
          properties = packagesResult.packageProperties;
        }

        emit(
          state.copyWith(
            packages: state.packages.copyWith(
              status: RequestStatus.success,
              data: packagesResult.packages,
            ),
            packageProperties: properties,
            selectedDuration: null,
            selectedVisits: null,
            selectedHoursNumber: null,
            selectedTimeSlotId: null,
          ),
        );
      },
    );
  }

  void updateSelectedDuration(int? duration) {
    emit(state.copyWith(selectedDuration: duration));
  }

  void updateSelectedVisits(int? visits) {
    emit(state.copyWith(selectedVisits: visits));
  }

  void updateSelectedHoursNumber(int? hours) {
    emit(state.copyWith(selectedHoursNumber: hours));
  }

  void updateSelectedTimeSlotId(String? timeSlotId) {
    emit(state.copyWith(selectedTimeSlotId: timeSlotId));
  }

  void resetState() {
    emit(const HourlyContractState());
  }

  /// ✅ Clear آمن (ما يعملش rebuild بدون داعي)
  void clearHourlyPricing() {
    if (state.hourlyPricingData == null &&
        state.hourlyPricingStatus == RequestStatus.initial) {
      return;
    }

    _lastRequestKey = null;

    emit(state.copyWith(
      hourlyPricingData: null,
      hourlyPricingStatus: RequestStatus.initial,
      hourlyPricingError: null,
    ));
  }

  /// ✅ دالة التسعير مع كل طبقات الحماية
  Future<void> fetchHourlyPricing({
    required String stepId,
    required Map<String, dynamic> data,
  }) async {
    final requestKey = data.toString();

    // 🛡️ الحماية 1: منع التكرار بناءً على مفتاح الطلب
    if (_lastRequestKey == requestKey) {
      print("⛔ [Cubit] Duplicate request blocked: $requestKey");
      return;
    }
    _lastRequestKey = requestKey;

    // 🛡️ الحماية 2: منع الـ Emit لو في طلب قيد التنفيذ
    if (state.hourlyPricingStatus == RequestStatus.loading) {
      print("⛔ [Cubit] Request already in progress");
      return;
    }

    print("🟢 [Cubit] Fetching HourlyPricing with data: $data");

    emit(state.copyWith(
      hourlyPricingStatus: RequestStatus.loading,
      hourlyPricingError: null,
    ));

    final result = await _shiftRepo.getHourlyPricing(
      stepId: stepId,
      data: data,
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          hourlyPricingStatus: RequestStatus.error,
          hourlyPricingError: failure.message,
        ));
      },
          (pricingData) {
        emit(state.copyWith(
          hourlyPricingStatus: RequestStatus.success,
          hourlyPricingData: pricingData,
        ));
      },
    );
  }
  Future<void> fetchContractSuccessData({required String stepId}) async {
    emit(
      state.copyWith(
        contractSuccessData: state.contractSuccessData.copyWith(status: RequestStatus.loading),
      ),
    );

    final result = await _shiftRepo.getContractSuccessData(stepId: stepId);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            contractSuccessData: state.contractSuccessData.copyWith(
              status: RequestStatus.error,
              error: failure.message,
            ),
          ),
        );
      },
          (successEntity) {
        emit(
          state.copyWith(
            contractSuccessData: state.contractSuccessData.copyWith(
              status: RequestStatus.success,
              data: [successEntity],
            ),
          ),
        );
      },
    );
  }
}