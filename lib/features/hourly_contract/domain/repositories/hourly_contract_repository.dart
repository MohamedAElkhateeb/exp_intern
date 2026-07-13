import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/model/available_days_params.dart';
import '../../data/model/hourly_pricing_response_model.dart';
import '../../data/model/time_slot_param.dart';
import '../entities/available_day_with_date_entity.dart';
import '../entities/contract_duration_entity.dart';
import '../entities/contract_success_entity.dart';
import '../entities/hourly_packages_result_entity.dart';
import '../entities/num_of_visits_entity.dart';
import '../entities/selected_package_entity.dart';
import '../entities/shift_entity.dart';
import '../entities/shift_hours_entity.dart';
import '../entities/time_slot_entity.dart';
import '../entities/worker_count_entity.dart';

abstract class HourlyContractRepository {
  Future<Either<Failure, List<ShiftEntity>>> getShifts({
    required String serviceId,
  });

  Future<Either<Failure, List<ContractDurationEntity>>> getContractDurations({
    required String serviceId,
  });

  Future<Either<Failure, List<NumOfVisitsEntity>>> getNumOfVisits({
    required String serviceId,
  });

  Future<Either<Failure, List<WorkerCountEntity>>> getWorkerCounts({
    required String serviceId,
  });

  Future<Either<Failure, List<TimeSlotEntity>>> getTimeSlots({
    required TimeSlotParams params,
  });

  Future<Either<Failure, List<ShiftHoursEntity>>> getShiftHours({
    required String serviceId,
    required int shift,
  });
  Future<Either<Failure, String>> getArrivalTime({
    required String timeSlotId,
  });
  Future<Either<Failure, List<AvailableDayWithDateEntity>>> getContractDates({
    required AvailableDaysParams params,
    required String stepId,
  });

  Future<Either<Failure, HourlyPackagesResultEntity>> getFixedPackages({
    required String stepId,
    required String nationalityId,
    required int shift,
  });
  Future<Either<Failure, HourlyPricingResponseModel>> getHourlyPricing({
    required String stepId,
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, ContractSuccessEntity>> getContractSuccessData({
    required String stepId,
  });
}
