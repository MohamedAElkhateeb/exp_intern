import 'package:dartz/dartz.dart';
import 'package:exp_intern/features/hourly_contract/domain/entities/shift_hours_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/available_day_with_date_entity.dart';
import '../../domain/entities/contract_duration_entity.dart';
import '../../domain/entities/contract_success_entity.dart';
import '../../domain/entities/hourly_packages_result_entity.dart';
import '../../domain/entities/num_of_visits_entity.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/worker_count_entity.dart';
import '../../domain/repositories/hourly_contract_repository.dart';
import '../data_source/hourly_contract_remote_data_source.dart';
import '../model/available_days_params.dart';
import '../model/hourly_pricing_response_model.dart';
import '../model/time_slot_param.dart';

@LazySingleton(as: HourlyContractRepository)
class HourlyContractRepositoryImpl implements HourlyContractRepository {
  final HourlyContractRemoteDataSource _remoteDataSource;

  HourlyContractRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ShiftEntity>>> getShifts({
    required String serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getShifts(serviceId: serviceId);
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ContractDurationEntity>>> getContractDurations({
    required String serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getContractDurations(
        serviceId: serviceId,
      );
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<NumOfVisitsEntity>>> getNumOfVisits({
    required String serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getNumOfVisits(
        serviceId: serviceId,
      );
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<WorkerCountEntity>>> getWorkerCounts({
    required String serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getWorkerCounts(
        serviceId: serviceId,
      );
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getTimeSlots({
    required TimeSlotParams params,
  }) async {
    try {
      final response = await _remoteDataSource.getTimeSlots(params: params);
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ShiftHoursEntity>>> getShiftHours({
    required String serviceId,
    required int shift,
  }) async {
    try {
      final response = await _remoteDataSource.getShiftHours(
        serviceId: serviceId,
        shift: shift,
      );
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<Either<Failure, String>> getArrivalTime({
    required String timeSlotId,
  }) async {
    try {
      final response = await _remoteDataSource.getArrivalTime(timeSlotId: timeSlotId);
      return Right(response.data ?? '');
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<Either<Failure, List<AvailableDayWithDateEntity>>> getContractDates({
    required AvailableDaysParams params,
    required String stepId,
  }) async {
    try {
      final response = await _remoteDataSource.getContractDates(params: params,stepId: stepId);
      return Right(response.data ?? []);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<Either<Failure, HourlyPackagesResultEntity>> getFixedPackages({
    required String stepId,
    required String nationalityId,
    required int shift,
  }) async {
    try {
      final response = await _remoteDataSource.getFixedPackages(
        stepId: stepId,
        nationalityId: nationalityId,
        shift: shift,
      );
      return Right(response.data!);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<Either<Failure, HourlyPricingResponseModel>> getHourlyPricing({
    required String stepId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _remoteDataSource.getHourlyPricing(
        stepId: stepId,
        data: data,
      );
      return Right(response.data!);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<Either<Failure, ContractSuccessEntity>> getContractSuccessData({
    required String stepId,
  }) async {
    try {
      final response = await _remoteDataSource.getContractSuccessData(stepId: stepId);
      return Right(response.data!);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
