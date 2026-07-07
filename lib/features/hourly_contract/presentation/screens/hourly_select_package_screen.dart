import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/utils/request_status_extension.dart';
import 'package:exp_intern/core/utils/routes_manager.dart';
import 'package:exp_intern/features/dynamic_steps/domain/entity/dynamic_step_entity.dart';
import 'package:exp_intern/features/hourly_contract/domain/entities/time_slot_entity.dart';
import 'package:exp_intern/features/resource_groub/presentation/cubit/resource_group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../../resource_groub/presentation/cubit/resource_group_state.dart';
import '../../data/model/time_slot_param.dart';
import '../../data/model/available_days_params.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/custom_contract_dropdown.dart';
import '../widgets/custom_contract_date_picker.dart';

class HourlySelectPackage extends StatefulWidget {
  final String serviceId;
  final String stepId;
  final DynamicStepEntity stepEntity;

  const HourlySelectPackage({
    super.key,
    required this.serviceId,
    required this.stepId,
    required this.stepEntity,
  });

  @override
  State<HourlySelectPackage> createState() => _HourlyContractScreenState();
}

class _HourlyContractScreenState extends State<HourlySelectPackage> {
  String? selectedNationalityId;
  int? selectedDurationId;
  int? selectedShiftId;
  int? selectedShiftHoursId;
  int? selectedNumOfVisitsId;
  int? selectedWorkerCountId;
  String? selectedTimeSlotId;
  DateTime? selectedFirstVisitDate;

  @override
  void initState() {
    super.initState();
    final hourlyCubit = context.read<HourlyContractCubit>();
    hourlyCubit.fetchShifts(serviceId: widget.serviceId);
    hourlyCubit.fetchContractDurations(serviceId: widget.serviceId);
    hourlyCubit.fetchNumOfVisits(serviceId: widget.serviceId);
    hourlyCubit.fetchWorkerCounts(serviceId: widget.serviceId);

    final resourceCubit = context.read<ResourceGroupCubit>();
    resourceCubit.getResourceGroups(serviceId: widget.serviceId);
  }

  void _fetchTimeSlotsIfNeeded() {
    if (selectedShiftId != null && selectedShiftHoursId != null) {
      context.read<HourlyContractCubit>().fetchTimeSlots(
        params: TimeSlotParams(
          serviceId: widget.serviceId,
          stepId: widget.stepId,
          shift: selectedShiftId!,
          hours: selectedShiftHoursId!,
        ),
      );
    }
  }

  void _fetchAvailableDaysIfNeeded(TimeSlotEntity? currentTimeSlot) {
    if (selectedTimeSlotId != null && selectedFirstVisitDate != null) {
      final daysString =
          currentTimeSlot?.enableDays?.join(',') ??
              "Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday";

      context.read<HourlyContractCubit>().fetchAvailableDays(
        params: AvailableDaysParams(
          selectedHourlyPricingId: null,
          resourceGroupId: selectedNationalityId ?? '',
          serviceId: widget.serviceId,
          contractStartDate: DateFormat(
            'dd/MM/yyyy',
          ).format(selectedFirstVisitDate!),
          contractDuration: selectedDurationId?.toString() ?? '1',
          hoursCount: selectedShiftHoursId?.toString() ?? '4',
          empcount: selectedWorkerCountId?.toString() ?? '1',
          weeklyvisits: selectedNumOfVisitsId?.toString() ?? '1',
          visitShift: selectedShiftId?.toString() ?? '1',
          promotionCode: null,
          days: daysString,
          timeSlotId: selectedTimeSlotId!,
        ),
        stepId: widget.stepId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: isDarkMode
          ? ColorsManager.darkBackground
          : ColorsManager.white,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? ColorsManager.darkBackground
            : ColorsManager.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleKeys.designYourOffer.tr(),
          style: textTheme.displayLarge?.copyWith(
            fontSize: 20.sp,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              size: 35.sp,
              Icons.notifications,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HourlyContractCubit, HourlyContractState>(
        builder: (context, state) {
          final resourceState = context.watch<ResourceGroupCubit>().state;

          if (state.shifts.status == RequestStatus.loading ||
              state.durations.status == RequestStatus.loading ||
              state.numOfVisits.status == RequestStatus.loading ||
              state.workerCounts.status == RequestStatus.loading ||
              resourceState.resourceGroupsStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          TimeSlotEntity? currentTimeSlot;
          if (selectedTimeSlotId != null && state.timeSlots.data.isNotEmpty) {
            final found = state.timeSlots.data.where(
                  (element) => element.key == selectedTimeSlotId,
            );
            if (found.isNotEmpty) currentTimeSlot = found.first;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<ResourceGroupCubit, ResourceGroupState>(
                  builder: (context, rState) {
                    return CustomContractDropdown<String>(
                      label: LocaleKeys.nationality.tr(),
                      hint: LocaleKeys.selectNationality.tr(),
                      value: selectedNationalityId,
                      items: rState.resourceGroups.map((nationality) {
                        return DropdownMenuItem<String>(
                          value: nationality.id,
                          child: Text(nationality.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedNationalityId = val),
                    );
                  },
                ),

                CustomContractDropdown<int>(
                  label: LocaleKeys.workerCount.tr(),
                  hint: LocaleKeys.selectWorkerCount.tr(),
                  value: selectedWorkerCountId,
                  items: state.workerCounts.data.map((worker) {
                    return DropdownMenuItem<int>(
                      value: worker.id,
                      child: Text(worker.value ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => selectedWorkerCountId = val),
                ),
                SizedBox(height: 16.h),

                CustomContractDropdown<int>(
                  label: LocaleKeys.contractDuration.tr(),
                  hint: LocaleKeys.selectDuration.tr(),
                  value: selectedDurationId,
                  items: state.durations.data.map((duration) {
                    return DropdownMenuItem<int>(
                      value: duration.id,
                      child: Text(duration.value ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDurationId = val;
                    });
                  },
                ),

                CustomContractDropdown<int>(
                  label: LocaleKeys.shifts.tr(),
                  hint: LocaleKeys.selectShift.tr(),
                  value: selectedShiftId,
                  items: state.shifts.data.map((shift) {
                    return DropdownMenuItem<int>(
                      value: shift.id,
                      child: Text(shift.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedShiftId = val;
                      selectedShiftHoursId = null;
                      selectedTimeSlotId = null;
                      selectedFirstVisitDate = null;
                    });
                    if (val != null) {
                      context.read<HourlyContractCubit>().getShiftHours(
                        serviceId: widget.serviceId,
                        shift: val,
                      );
                    }
                  },
                ),

                BlocBuilder<HourlyContractCubit, HourlyContractState>(
                  buildWhen: (previous, current) =>
                  previous.shiftHours.status != current.shiftHours.status ||
                      previous.shiftHours.data != current.shiftHours.data,
                  builder: (context, state) {
                    final hasData =
                        state.shiftHours.data.isNotEmpty && selectedShiftId != null;

                    return CustomContractDropdown<int>(
                      label: LocaleKeys.visitDuration.tr(),
                      hint: hasData
                          ? LocaleKeys.selectVisitDuration.tr()
                          : LocaleKeys.selectShiftFirst.tr(),
                      value: selectedShiftHoursId,
                      items: hasData
                          ? state.shiftHours.data.map((hours) {
                        return DropdownMenuItem<int>(
                          value: hours.id,
                          child: Text(hours.value ?? ''),
                        );
                      }).toList()
                          : [],
                      onChanged: (val) {
                        if (hasData) {
                          setState(() {
                            selectedShiftHoursId = val;
                            selectedTimeSlotId = null;
                            selectedFirstVisitDate = null;
                          });
                          _fetchTimeSlotsIfNeeded();
                        }
                      },
                    );
                  },
                ),

                _buildDeliveryNotes(isDarkMode, state),
                SizedBox(height: 16.h),

                BlocBuilder<HourlyContractCubit, HourlyContractState>(
                  buildWhen: (previous, current) =>
                  previous.timeSlots.status != current.timeSlots.status ||
                      previous.timeSlots.data != current.timeSlots.data,
                  builder: (context, state) {
                    final hasData =
                        state.timeSlots.data.isNotEmpty &&
                            selectedShiftHoursId != null;

                    return CustomContractDropdown<String>(
                      label: LocaleKeys.visitTime.tr(),
                      hint: hasData
                          ? LocaleKeys.selectVisitTime.tr()
                          : LocaleKeys.selectVisitDurationFirst.tr(),
                      value: selectedTimeSlotId,
                      items: hasData
                          ? state.timeSlots.data.map((timeSlot) {
                        return DropdownMenuItem<String>(
                          value: timeSlot.key,
                          child: Text(timeSlot.value ?? ''),
                        );
                      }).toList()
                          : [],
                      onChanged: (val) {
                        if (hasData) {
                          setState(() {
                            selectedTimeSlotId = val;
                            selectedFirstVisitDate = null;
                          });

                          if (val != null) {
                            context
                                .read<HourlyContractCubit>()
                                .fetchArrivalTime(timeSlotId: val);
                          }
                        }
                      },
                    );
                  },
                ),

                CustomContractDropdown<int>(
                  label: LocaleKeys.numberOfVisits.tr(),
                  hint: LocaleKeys.selectNumberOfVisits.tr(),
                  value: selectedNumOfVisitsId,
                  items: state.numOfVisits.data.map((visit) {
                    return DropdownMenuItem<int>(
                      value: visit.id,
                      child: Text(visit.value ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => selectedNumOfVisitsId = val),
                ),

                SizedBox(height: 16.h),

                StatefulBuilder(
                  builder: (context, setPickerState) {
                    return CustomContractDatePicker(
                      selectedDate: selectedFirstVisitDate,
                      selectedTimeSlotId: selectedTimeSlotId,
                      currentTimeSlot: currentTimeSlot,
                      isDarkMode: isDarkMode,
                      onDateSelected: (pickedDate) {
                        setState(() {
                          selectedFirstVisitDate = pickedDate;
                        });
                        setPickerState(() {});
                        _fetchAvailableDaysIfNeeded(currentTimeSlot);
                      },
                    );
                  },
                ),

                SizedBox(height: 32.h),

                ElevatedButton(
                  onPressed: () {
                    if (selectedTimeSlotId != null &&
                        selectedFirstVisitDate != null) {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.HourlyPackagePromotion,
                        arguments:{
                          'serviceId': widget.serviceId,
                          'stepEntity': widget.stepEntity,
                          'cubit': context.read<HourlyContractCubit>(),
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? ColorsManager.white
                        : ColorsManager.black,
                    foregroundColor: isDarkMode
                        ? ColorsManager.black
                        : ColorsManager.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.next.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryNotes(bool isDarkMode, HourlyContractState state) {
    if (state.arrivalTimeStatus.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (state.deliveryNotesText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              state.deliveryNotesText,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}