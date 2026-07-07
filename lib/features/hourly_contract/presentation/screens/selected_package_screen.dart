import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/utils/routes_manager.dart';
import 'package:exp_intern/features/hourly_contract/domain/entities/selected_package_entity.dart';
import 'package:exp_intern/features/resource_groub/domain/entities/nationality_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../../../core/widgets/app_calendar_picker.dart';
import '../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_state.dart';
import '../../../resource_groub/presentation/cubit/resource_group_cubit.dart';
import '../../../resource_groub/presentation/cubit/resource_group_state.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/shift_hours_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/contract_duration_entity.dart';
import '../../data/model/time_slot_param.dart';
import '../../data/model/available_days_params.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/delivery_notes_widget.dart';
import '../widgets/horizontal_filter_widget.dart';
import '../widgets/package_item_widget.dart';

class SelectPackageScreen extends StatefulWidget {
  final String serviceId;
  final DynamicStepEntity stepEntity;

  const SelectPackageScreen({
    super.key,
    required this.serviceId,
    required this.stepEntity,
  });

  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  NationalityEntity? _selectedNationalityEntity;
  ShiftEntity? _selectedShiftEntity;
  ShiftHoursEntity? _selectedHourEntity;
  TimeSlotEntity? _selectedTimeSlotEntity;
  ContractDurationEntity? _selectedDurationEntity;
  SelectedPackageEntity? _selectedPackage;

  DateTime? _selectedContractDate;

  int _expandedPackageIndex = 0;

  static const String selectCalendarStep = "SelectCalender";

  @override
  void initState() {
    super.initState();
    context.read<ResourceGroupCubit>().getResourceGroups(
      serviceId: widget.serviceId,
    );
    context.read<HourlyContractCubit>().fetchShifts(
      serviceId: widget.serviceId,
    );
    context.read<HourlyContractCubit>().fetchContractDurations(
      serviceId: widget.serviceId,
    );
  }

  @override
  void dispose() {
    context.read<DynamicStepsCubit>().resetState();
    context.read<HourlyContractCubit>().resetState();

    super.dispose();
  }

  void _handleStepNavigation(DynamicStepEntity nextStep) {
    final int stepType = nextStep.stepType ?? 0;

    if (stepType == 6) {
      _showStepPopup(nextStep);
    } else if (stepType == 2 || stepType == 8) {
      Navigator.of(context).pushNamed(
        nextStep.name ?? '',
        arguments: {'serviceId': widget.serviceId, 'stepEntity': nextStep},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${LocaleKeys.step_not_supported.tr()} $stepType',
          ),
        ),
      );
    }
  }

  Future<void> _showStepPopup(DynamicStepEntity nextStep) async {
    final hourlyContractCubit = context.read<HourlyContractCubit>();

    await showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isDarkMode =
            Theme.of(dialogContext).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (popupContext, setPopupState) {
            return Dialog(
              backgroundColor: isDarkMode
                  ? ColorsManager.darkBackground
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          nextStep.name == selectCalendarStep
                              ? LocaleKeys.selectFirstVisitDate.tr()
                              : (nextStep.name ?? LocaleKeys.alert.tr()),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? ColorsManager.white
                                : ColorsManager.black,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        if (nextStep.name == selectCalendarStep) ...[
                          AppCalendarPicker(
                            selectedDate: _selectedContractDate,
                            isDarkMode: isDarkMode,
                            minDateString: _selectedTimeSlotEntity?.minDate,
                            maxDateString: _selectedTimeSlotEntity?.maxDate,
                            onDateSelected: (date) {
                              setPopupState(() {
                                _selectedContractDate = date;
                              });
                              setState(() {
                                _selectedContractDate = date;
                              });
                            },
                          ),
                          SizedBox(height: 20.h),
                        ] else ...[
                          Text(
                            nextStep.description ??
                                LocaleKeys.please_confirm_next_step.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        ElevatedButton(
                          onPressed: () {
                            if (nextStep.name == selectCalendarStep &&
                                _selectedContractDate == null) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LocaleKeys.please_select_visit_date_first
                                        .tr(),
                                  ),
                                ),
                              );
                              return;
                            }

                            if (nextStep.name == selectCalendarStep &&
                                _selectedPackage != null) {
                              final package = _selectedPackage!;
                              final formattedDate = DateFormat(
                                'dd/MM/yyyy',
                              ).format(_selectedContractDate!);

                              final days =
                                  _selectedTimeSlotEntity?.enableDays?.join(
                                    ',',
                                  ) ??
                                  '';
                              hourlyContractCubit.fetchAvailableDays(
                                params: AvailableDaysParams(
                                  selectedHourlyPricingId:
                                      package.selectedHourlyPricingId,
                                  resourceGroupId: package.resourceGroupId,
                                  serviceId: package.serviceId,
                                  contractStartDate: formattedDate,
                                  contractDuration: package.contractDuration
                                      .toString(),
                                  hoursCount: package.hoursNumber.toString(),
                                  empcount: package.employeeNumber.toString(),
                                  weeklyvisits: package.weeklyVisits.toString(),
                                  visitShift: package.visitShift.toString(),
                                  promotionCode: package.promotionCode,
                                  days: days,
                                  timeSlotId: package.timeSlotId,
                                ),
                                stepId:
                                    nextStep.stepId ??
                                    widget.stepEntity.stepId ??
                                    '',
                              );

                              Navigator.of(dialogContext).pop();

                              final targetRoute = nextStep.nextStepAction ?? '';

                              Navigator.of(context).pushNamed(
                                targetRoute,
                                arguments: {
                                  'serviceId': widget.serviceId,
                                  'stepEntity': nextStep,
                                  'cubit': hourlyContractCubit,
                                },
                              );
                              return;
                            }

                            Navigator.of(dialogContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(140.w, 45.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            LocaleKeys.next.tr(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -15.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.close,
                            size: 18.w,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _triggerFetchTimeSlots() {
    if (_selectedShiftEntity != null && _selectedHourEntity != null) {
      context.read<HourlyContractCubit>().fetchTimeSlots(
        params: TimeSlotParams(
          serviceId: widget.serviceId,
          stepId: widget.stepEntity.stepId ?? '',
          shift: _selectedShiftEntity!.id ?? 0,
          hours: _selectedHourEntity!.id ?? 0,
        ),
      );
    }
  }

  void _triggerFetchPackages() {
    if (_selectedNationalityEntity != null && _selectedShiftEntity != null) {
      context.read<HourlyContractCubit>().fetchFixedPackages(
        stepId: widget.stepEntity.stepId ?? '',
        nationalityId: _selectedNationalityEntity!.id ?? '',
        shift: _selectedShiftEntity!.id ?? 0,
      );
    }
  }

  void _fetchDeliveryNotesAutomatically() {
    if (_selectedTimeSlotEntity?.key != null) {
      context.read<HourlyContractCubit>().fetchArrivalTime(
        timeSlotId: _selectedTimeSlotEntity!.key!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          LocaleKeys.select_package.tr(),
          style: textTheme.displayLarge?.copyWith(
            fontSize: 20.sp,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<DynamicStepsCubit, DynamicStepsState>(
          listener: (context, dynamicState) {
            if (dynamicState.isSubmitSuccess &&
                dynamicState.stepEntity != null) {
              final nextStep = dynamicState.stepEntity!;

              context.read<DynamicStepsCubit>().resetState();

              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              _handleStepNavigation(nextStep);
            }

            if (dynamicState.isSubmitError) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    dynamicState.failure?.message ??
                        LocaleKeys.something_went_wrong_try_again.tr(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      LocaleKeys.nationality.tr(),
                      isDarkMode,
                      textTheme,
                    ),
                    BlocBuilder<ResourceGroupCubit, ResourceGroupState>(
                      buildWhen: (previous, current) =>
                          previous.resourceGroups != current.resourceGroups ||
                          previous.resourceGroupsStatus !=
                              current.resourceGroupsStatus,
                      builder: (context, state) {
                        if (state.resourceGroupsStatus ==
                            RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.resourceGroupsStatus == RequestStatus.error) {
                          return Text(
                            state.errorMessage ?? LocaleKeys.error_loading_nationalities.tr(),
                          );
                        }
                        if (state.resourceGroups.isEmpty) {
                          return  Text(LocaleKeys.no_nationalities_available.tr());
                        }

                        if (_selectedNationalityEntity == null) {
                          _selectedNationalityEntity =
                              state.resourceGroups.first;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _triggerFetchPackages(),
                          );
                        }

                        final nationalityNames = state.resourceGroups
                            .map((e) => e.name as String)
                            .toList();
                        final currentName =
                            _selectedNationalityEntity?.name ?? '';

                        return HorizontalFilterWidget(
                          items: nationalityNames,
                          selectedValue: currentName,
                          isDarkMode: isDarkMode,
                          onSelected: (name) {
                            setState(() {
                              _selectedNationalityEntity = state.resourceGroups
                                  .firstWhere((e) => e.name == name);
                            });
                            _triggerFetchPackages();
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle(
                      LocaleKeys.shifts.tr(),
                      isDarkMode,
                      textTheme,
                    ),

                    BlocBuilder<HourlyContractCubit, HourlyContractState>(
                      buildWhen: (previous, current) =>
                          previous.shifts.status != current.shifts.status ||
                          previous.shifts.data != current.shifts.data,
                      builder: (context, state) {
                        if (state.shifts.status == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.shifts.data.isEmpty) {
                          return  Text(LocaleKeys.no_shifts_available.tr());
                        }

                        if (_selectedShiftEntity == null) {
                          _selectedShiftEntity = state.shifts.data.first;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _triggerFetchPackages();
                            context.read<HourlyContractCubit>().getShiftHours(
                              serviceId: widget.serviceId,
                              shift: _selectedShiftEntity!.id ?? 0,
                            );
                          });
                        }

                        final shiftNames = state.shifts.data
                            .map((e) => e.name ?? '')
                            .toList();
                        final currentShiftName =
                            _selectedShiftEntity?.name ?? '';

                        return HorizontalFilterWidget(
                          items: shiftNames,
                          selectedValue: currentShiftName,
                          isDarkMode: isDarkMode,
                          fixedWidth: 100.w,
                          onSelected: (name) {
                            setState(() {
                              _selectedShiftEntity = state.shifts.data
                                  .firstWhere((e) => e.name == name);
                              _selectedHourEntity = null;
                              _selectedTimeSlotEntity = null;
                              _selectedDurationEntity = null;
                            });
                            _triggerFetchPackages();
                            context.read<HourlyContractCubit>().getShiftHours(
                              serviceId: widget.serviceId,
                              shift: _selectedShiftEntity!.id ?? 0,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle(
                      LocaleKeys.visitDuration.tr(),
                      isDarkMode,
                      textTheme,
                    ),

                    BlocBuilder<HourlyContractCubit, HourlyContractState>(
                      buildWhen: (previous, current) =>
                          previous.shiftHours.status !=
                              current.shiftHours.status ||
                          previous.shiftHours.data != current.shiftHours.data,
                      builder: (context, state) {
                        if (state.shiftHours.status == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.shiftHours.data.isEmpty) {
                          return  Text(LocaleKeys.no_shift_hours_available.tr());
                        }

                        if (_selectedHourEntity == null) {
                          _selectedHourEntity = state.shiftHours.data.first;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _triggerFetchTimeSlots(),
                          );
                        }

                        final hourValues = state.shiftHours.data
                            .map((e) => e.value ?? '')
                            .toList();
                        final currentHourValue =
                            _selectedHourEntity?.value ?? '';

                        return HorizontalFilterWidget(
                          items: hourValues,
                          selectedValue: currentHourValue,
                          isDarkMode: isDarkMode,
                          onSelected: (val) {
                            setState(() {
                              _selectedHourEntity = state.shiftHours.data
                                  .firstWhere((e) => e.value == val);
                              _selectedTimeSlotEntity = null;
                              _selectedDurationEntity = null;
                            });
                            _triggerFetchTimeSlots();
                            context
                                .read<HourlyContractCubit>()
                                .updateSelectedHoursNumber(
                                  _selectedHourEntity?.id,
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle(
                      LocaleKeys.visitTime.tr(),
                      isDarkMode,
                      textTheme,
                    ),
                    BlocBuilder<HourlyContractCubit, HourlyContractState>(
                      buildWhen: (previous, current) =>
                          previous.timeSlots.status !=
                              current.timeSlots.status ||
                          previous.timeSlots.data != current.timeSlots.data,
                      builder: (context, state) {
                        if (state.timeSlots.status == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.timeSlots.data.isEmpty) {
                          return  Text(
                            LocaleKeys.no_time_slots_available.tr(),
                          );
                        }

                        if (_selectedTimeSlotEntity == null ||
                            !state.timeSlots.data.contains(
                              _selectedTimeSlotEntity,
                            )) {
                          _selectedTimeSlotEntity = state.timeSlots.data.first;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _fetchDeliveryNotesAutomatically();
                          });
                        }

                        final timeSlotValues = state.timeSlots.data
                            .map((e) => e.value ?? '')
                            .toList();
                        final currentTimeSlotValue =
                            _selectedTimeSlotEntity?.value ?? '';

                        return HorizontalFilterWidget(
                          items: timeSlotValues,
                          selectedValue: currentTimeSlotValue,
                          isDarkMode: isDarkMode,
                          onSelected: (val) {
                            setState(() {
                              _selectedTimeSlotEntity = state.timeSlots.data
                                  .firstWhere((e) => e.value == val);
                              _selectedDurationEntity = null;
                            });
                            _fetchDeliveryNotesAutomatically();
                            context
                                .read<HourlyContractCubit>()
                                .updateSelectedTimeSlotId(
                                  _selectedTimeSlotEntity?.key,
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildSectionTitle(
                      LocaleKeys.contractDuration.tr(),
                      isDarkMode,
                      textTheme,
                    ),
                    BlocBuilder<HourlyContractCubit, HourlyContractState>(
                      buildWhen: (previous, current) =>
                          previous.durations.status !=
                              current.durations.status ||
                          previous.durations.data != current.durations.data,
                      builder: (context, state) {
                        if (state.durations.status == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.durations.data.isEmpty) {
                          return  Text(LocaleKeys.no_durations_available.tr());
                        }

                        _selectedDurationEntity ??= state.durations.data.first;

                        final durationValues = state.durations.data
                            .map((e) => e.value ?? '')
                            .toList();
                        final currentDurationValue =
                            _selectedDurationEntity?.value ?? '';

                        return HorizontalFilterWidget(
                          items: durationValues,
                          selectedValue: currentDurationValue,
                          isDarkMode: isDarkMode,
                          onSelected: (val) {
                            setState(() {
                              _selectedDurationEntity = state.durations.data
                                  .firstWhere((e) => e.value == val);
                            });
                            context
                                .read<HourlyContractCubit>()
                                .updateSelectedDuration(
                                  _selectedDurationEntity?.id,
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    DeliveryNotesWidget(isDarkMode: isDarkMode),
                    SizedBox(height: 20.h),

                    _buildSectionTitle(
                      LocaleKeys.packages.tr(),
                      isDarkMode,
                      textTheme,
                    ),

                    BlocBuilder<HourlyContractCubit, HourlyContractState>(
                      buildWhen: (previous, current) =>
                          previous.packages != current.packages ||
                          previous.selectedDuration !=
                              current.selectedDuration ||
                          previous.selectedVisits != current.selectedVisits ||
                          previous.selectedHoursNumber !=
                              current.selectedHoursNumber ||
                          previous.selectedTimeSlotId !=
                              current.selectedTimeSlotId,
                      builder: (context, state) {
                        if (state.packages.status == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.packages.status == RequestStatus.error) {
                          return Center(
                            child: Text(
                              state.packages.error ??
                                  state.packages.error ?? LocaleKeys.error_loading_packages.tr(),
                            ),
                          );
                        }
                        if (state.packages.data.isEmpty) {
                          return  Center(
                            child: Text(LocaleKeys.no_packages_available.tr()),
                          );
                        }

                        final filteredPackages = state.filteredPackages;

                        if (filteredPackages.isEmpty) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: Text(
                                LocaleKeys.no_packages_match_filters.tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPackages.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final package = filteredPackages[index];
                            return PackageItemWidget(
                              index: index,
                              isExpanded: _expandedPackageIndex == index,
                              isDarkMode: isDarkMode,
                              package: package,
                              properties: state.packageProperties,
                              onExpand: () {
                                setState(() {
                                  _expandedPackageIndex =
                                      _expandedPackageIndex == index
                                      ? -1
                                      : index;
                                });
                              },
                              onSelect: () {
                                setState(() {
                                  _selectedPackage = package;
                                });
                                context
                                    .read<DynamicStepsCubit>()
                                    .executeDynamicStep(
                                      controller:
                                          widget.stepEntity.controller ?? '',
                                      action: widget.stepEntity.action ?? '',
                                      method:
                                          widget.stepEntity.httpMethod ??
                                          'POST',
                                      queryParameters: {
                                        "selectedPricingId":
                                            package.selectedHourlyPricingId,
                                        "stepId":
                                            widget.stepEntity.stepId ?? "",
                                      },
                                    );
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesManager.hourlySelectPackage,
                        arguments: {
                          'serviceId': widget.serviceId,
                          'stepId': widget.stepEntity.stepId,
                          'stepEntity': widget.stepEntity,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.black,
                      foregroundColor: ColorsManager.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      LocaleKeys.designYourOffer.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    bool isDarkMode,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: textTheme.displayMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
        ),
      ),
    );
  }
}
