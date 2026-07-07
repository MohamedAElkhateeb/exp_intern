import '../../../../core/utils/dataState_generic_state.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../domain/entities/available_day_with_date_entity.dart';
import '../../domain/entities/contract_duration_entity.dart';
import '../../domain/entities/num_of_visits_entity.dart';
import '../../domain/entities/package_property_configEntity.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/shift_hours_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/worker_count_entity.dart';

class HourlyContractState {
  final DataState<ShiftEntity> shifts;
  final DataState<ShiftHoursEntity> shiftHours;
  final DataState<ContractDurationEntity> durations;
  final DataState<NumOfVisitsEntity> numOfVisits;
  final DataState<WorkerCountEntity> workerCounts;
  final DataState<TimeSlotEntity> timeSlots;
  final DataState<AvailableDayWithDateEntity> availableDays;
  final DataState<SelectedPackageEntity> packages;

  final Map<String, PackagePropertyConfigEntity> packageProperties;

  final RequestStatus arrivalTimeStatus;
  final String deliveryNotesText;

  final int? selectedDuration;
  final int? selectedVisits;
  final int? selectedHoursNumber;
  final String? selectedTimeSlotId;

  const HourlyContractState({
    this.shifts = const DataState(),
    this.shiftHours = const DataState(),
    this.durations = const DataState(),
    this.numOfVisits = const DataState(),
    this.workerCounts = const DataState(),
    this.timeSlots = const DataState(),
    this.availableDays = const DataState(),
    this.packages = const DataState(),
    this.packageProperties = const {},
    this.arrivalTimeStatus = RequestStatus.initial,
    this.deliveryNotesText = '',
    this.selectedDuration,
    this.selectedVisits,
    this.selectedHoursNumber,
    this.selectedTimeSlotId,
  });

  List<SelectedPackageEntity> get filteredPackages {
    if (packages.data.isEmpty) return [];

    return packages.data.where((package) {
      final matchDuration =
          selectedDuration == null || package.contractDuration == selectedDuration;

      final matchVisits =
          selectedVisits == null || package.weeklyVisits == selectedVisits;

      final matchHours =
          selectedHoursNumber == null || package.hoursNumber == selectedHoursNumber;

      final matchTimeSlot =
          selectedTimeSlotId == null || package.timeSlotId == selectedTimeSlotId;

      return matchDuration && matchVisits && matchHours && matchTimeSlot;
    }).toList();
  }

  HourlyContractState copyWith({
    DataState<ShiftEntity>? shifts,
    DataState<ShiftHoursEntity>? shiftHours,
    DataState<ContractDurationEntity>? durations,
    DataState<NumOfVisitsEntity>? numOfVisits,
    DataState<WorkerCountEntity>? workerCounts,
    DataState<TimeSlotEntity>? timeSlots,
    DataState<AvailableDayWithDateEntity>? availableDays,
    DataState<SelectedPackageEntity>? packages,
    Map<String, PackagePropertyConfigEntity>? packageProperties,
    RequestStatus? arrivalTimeStatus,
    String? deliveryNotesText,
    int? selectedDuration,
    int? selectedVisits,
    int? selectedHoursNumber,
    String? selectedTimeSlotId,
  }) {
    return HourlyContractState(
      shifts: shifts ?? this.shifts,
      shiftHours: shiftHours ?? this.shiftHours,
      durations: durations ?? this.durations,
      numOfVisits: numOfVisits ?? this.numOfVisits,
      workerCounts: workerCounts ?? this.workerCounts,
      timeSlots: timeSlots ?? this.timeSlots,
      availableDays: availableDays ?? this.availableDays,
      packages: packages ?? this.packages,
      packageProperties: packageProperties ?? this.packageProperties,
      arrivalTimeStatus: arrivalTimeStatus ?? this.arrivalTimeStatus,
      deliveryNotesText: deliveryNotesText ?? this.deliveryNotesText,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedVisits: selectedVisits ?? this.selectedVisits,
      selectedHoursNumber: selectedHoursNumber ?? this.selectedHoursNumber,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
    );
  }
}