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
import '../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_state.dart';
import '../../../resource_groub/presentation/cubit/resource_group_cubit.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/shift_hours_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/contract_duration_entity.dart';
import '../../data/model/time_slot_param.dart';
import '../../data/model/available_days_params.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/delivery_notes_widget.dart';
import '../widgets/package_item_widget.dart';
// ✅ Import the extracted widgets
import '../widgets/filters/nationality_filter_widget.dart';
import '../widgets/filters/shift_filter_widget.dart';
import '../widgets/filters/visit_duration_filter_widget.dart';
import '../widgets/filters/visit_time_filter_widget.dart';
import '../widgets/filters/contract_duration_filter_widget.dart';
import '../widgets/dialogs/calendar_dialog.dart';
import '../widgets/dialogs/confirmation_dialog.dart';
import '../widgets/section_title_widget.dart';

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

  int _expandedPackageIndex = -1;

  static const String selectCalendarStep = "SelectCalender";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
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
    super.dispose();
  }

  void _handleStepNavigation(DynamicStepEntity nextStep) {
    final stepType = nextStep.stepType ?? 0;

    switch (stepType) {
      case 6:
        _showStepPopup(nextStep);
        break;
      case 2:
      case 8:
        _navigateToStep(nextStep);
        break;
      default:
break;
    }
  }

  void _navigateToStep(DynamicStepEntity nextStep) {
    Navigator.of(context).pushNamed(
      nextStep.name ?? '',
      arguments: {'serviceId': widget.serviceId, 'stepEntity': nextStep},
    );
  }

  void _showUnsupportedStepMessage(int stepType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${LocaleKeys.step_not_supported.tr()} $stepType'),
      ),
    );
  }

  Future<void> _showStepPopup(DynamicStepEntity nextStep) async {
    if (nextStep.name == selectCalendarStep) {
      await _showCalendarPopup(nextStep);
    } else {
      await _showConfirmationPopup(nextStep);
    }
  }

  Future<void> _showCalendarPopup(DynamicStepEntity nextStep) async {
    final hourlyContractCubit = context.read<HourlyContractCubit>();

    if (_selectedContractDate == null) {
      if (_selectedTimeSlotEntity?.minDate != null) {
        try {
          final minDate = DateFormat('yyyy-MM-dd').parse(_selectedTimeSlotEntity!.minDate!);
          _selectedContractDate = minDate;
        } catch (e) {
          _selectedContractDate = DateTime.now();
        }
      } else {
        _selectedContractDate = DateTime.now();
      }
    }
    await showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (dialogContext) {
        return CalendarDialog(
          selectedDate: _selectedContractDate,
          nextStep: nextStep,
          timeSlotEntity: _selectedTimeSlotEntity,
          hourlyContractCubit: hourlyContractCubit,
          onDateSelected: (date) {
            setState(() {
              _selectedContractDate = date;
            });
          },
          onConfirm: () {
            if (_selectedContractDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.please_select_visit_date_first.tr()),
                ),
              );
              return;
            }

            if (_selectedPackage != null) {
              _handleCalendarConfirmation(
                dialogContext: dialogContext,
                nextStep: nextStep,
                hourlyContractCubit: hourlyContractCubit,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.please_select_visit_date_first.tr()),
                ),
              );
            }
          },
        );
      },
    );
  }
  Future<void> _showConfirmationPopup(DynamicStepEntity nextStep) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ConfirmationDialog(
          nextStep: nextStep,
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            // Handle confirmation logic here if needed
          },
        );
      },
    );
  }

  void _handleCalendarConfirmation({
    required BuildContext dialogContext,
    required DynamicStepEntity nextStep,
    required HourlyContractCubit hourlyContractCubit,
  }) {
    final package = _selectedPackage!;
    if (_selectedTimeSlotEntity?.minDate != null) {
      try {
        final minDateStr = _selectedTimeSlotEntity!.minDate!;
        DateTime minDate;
        try {
          minDate = DateFormat('yyyy-MM-dd').parse(minDateStr);
        } catch (_) {
          minDate = DateFormat('M/d/yyyy').parse(minDateStr);
        }

        if (_selectedContractDate!.isBefore(minDate)) {
          _selectedContractDate = minDate;
        }
      } catch (_) {}
    }
    final formattedDate = DateFormat('dd/MM/yyyy').format(_selectedContractDate!);

    final days = _selectedTimeSlotEntity?.enableDays?.join(',') ?? '';

    final params = AvailableDaysParams(
      selectedHourlyPricingId: package.selectedHourlyPricingId,
      resourceGroupId: package.resourceGroupId,
      serviceId: package.serviceId,
      contractStartDate: formattedDate,
      contractDuration: package.contractDuration.toString(),
      hoursCount: package.hoursNumber.toString(),
      empcount: package.employeeNumber.toString(),
      weeklyvisits: package.weeklyVisits.toString(),
      visitShift: package.visitShift.toString(),
      promotionCode: package.promotionCode,
      days: days,
      timeSlotId: package.timeSlotId,
    );

    final stepId = nextStep.stepId ?? widget.stepEntity.stepId ?? '';

    hourlyContractCubit.fetchAvailableDays(
      params: params,
      stepId: stepId,
    );

    hourlyContractCubit.fetchHourlyPricing(
      stepId: stepId,
      data: {
        'selectedHourlyPricingId': package.selectedHourlyPricingId,
        'resourceGroupId': package.resourceGroupId,
        'serviceId': widget.serviceId,
        'contractStartDate': formattedDate,
        'contractDuration': package.contractDuration.toString(),
        'hoursCount': package.hoursNumber.toString(),
        'empcount': package.employeeNumber.toString(),
        'weeklyvisits': package.weeklyVisits.toString(),
        'visitShift': package.visitShift.toString(),
        'promotionCode': package.promotionCode,
        'days': days,
        'timeSlotId': package.timeSlotId,
      },
    );

    Navigator.of(dialogContext).pop();

    final targetRoute = nextStep.nextStepAction ?? '';

    Navigator.of(context).pushNamed(
      targetRoute,
      arguments: {
        'serviceId': widget.serviceId,
        'stepEntity': nextStep,
        'cubit': hourlyContractCubit,
        'selectedPackage': package,
        'contractData': {
          'contractStartDate': formattedDate,
          'days': days,
        },
      },
    );
  }

  void _triggerFetchTimeSlots() {
    if (_selectedShiftEntity == null || _selectedHourEntity == null) return;

    context.read<HourlyContractCubit>().fetchTimeSlots(
      params: TimeSlotParams(
        serviceId: widget.serviceId,
        stepId: widget.stepEntity.stepId ?? '',
        shift: _selectedShiftEntity!.id ?? 0,
        hours: _selectedHourEntity!.id ?? 0,
      ),
    );
  }

  void _triggerFetchPackages() {
    if (_selectedNationalityEntity == null || _selectedShiftEntity == null) return;

    context.read<HourlyContractCubit>().fetchFixedPackages(
      stepId: widget.stepEntity.stepId ?? '',
      nationalityId: _selectedNationalityEntity!.id ?? '',
      shift: _selectedShiftEntity!.id ?? 0,
    );
  }

  void _fetchDeliveryNotesAutomatically() {
    if (_selectedTimeSlotEntity?.key == null) return;

    context.read<HourlyContractCubit>().fetchArrivalTime(
      timeSlotId: _selectedTimeSlotEntity!.key!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(isDarkMode, textTheme),
      body: SafeArea(
        child: BlocListener<DynamicStepsCubit, DynamicStepsState>(
          listener: _handleDynamicStepState,
          child: Stack(
            children: [
              _buildMainContent(isDarkMode, textTheme),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDarkMode, TextTheme textTheme) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        LocaleKeys.select_package.tr(),
        style: textTheme.displayLarge?.copyWith(
          fontSize: 20.sp,
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
      ),
    );
  }

  void _handleDynamicStepState(BuildContext context, DynamicStepsState dynamicState) {
    if (dynamicState.isSubmitSuccess && dynamicState.stepEntity != null) {
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
            dynamicState.failure?.message ?? LocaleKeys.something_went_wrong_try_again.tr(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildMainContent(bool isDarkMode, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Nationality Filter
          SectionTitleWidget(
            title: LocaleKeys.nationality.tr(),
            isDarkMode: isDarkMode,
          ),
          NationalityFilterWidget(
            isDarkMode: isDarkMode,
            selectedNationality: _selectedNationalityEntity,
            onSelected: (entity) {
              setState(() {
                _selectedNationalityEntity = entity;
              });
              _triggerFetchPackages();
            },
          ),
          SizedBox(height: 16.h),

          // ✅ Shifts Filter
          SectionTitleWidget(
            title: LocaleKeys.shifts.tr(),
            isDarkMode: isDarkMode,
          ),
          ShiftFilterWidget(
            isDarkMode: isDarkMode,
            serviceId: widget.serviceId,
            selectedShift: _selectedShiftEntity,
            onSelected: (shift) {
              setState(() {
                _selectedShiftEntity = shift;
                _selectedHourEntity = null;
                _selectedTimeSlotEntity = null;
                _selectedDurationEntity = null;
              });
              _triggerFetchPackages();
              context.read<HourlyContractCubit>().getShiftHours(
                serviceId: widget.serviceId,
                shift: shift.id ?? 0,
              );
            },
          ),
          SizedBox(height: 16.h),

          // ✅ Visit Duration Filter
          SectionTitleWidget(
            title: LocaleKeys.visitDuration.tr(),
            isDarkMode: isDarkMode,
          ),
          VisitDurationFilterWidget(
            isDarkMode: isDarkMode,
            selectedHour: _selectedHourEntity,
            onSelected: (hour) {
              setState(() {
                _selectedHourEntity = hour;
                _selectedTimeSlotEntity = null;
                _selectedDurationEntity = null;
              });
              _triggerFetchTimeSlots();
              context.read<HourlyContractCubit>().updateSelectedHoursNumber(
                _selectedHourEntity?.id,
              );
            },
          ),
          SizedBox(height: 16.h),

          SectionTitleWidget(
            title: LocaleKeys.visitTime.tr(),
            isDarkMode: isDarkMode,
          ),
          VisitTimeFilterWidget(
            isDarkMode: isDarkMode,
            selectedTimeSlot: _selectedTimeSlotEntity,
            onSelected: (timeSlot) {
              setState(() {
                _selectedTimeSlotEntity = timeSlot;
                _selectedDurationEntity = null;
              });
              _fetchDeliveryNotesAutomatically();
              context.read<HourlyContractCubit>().updateSelectedTimeSlotId(
                _selectedTimeSlotEntity?.key,
              );
            },
          ),
          SizedBox(height: 16.h),

          SectionTitleWidget(
            title: LocaleKeys.contractDuration.tr(),
            isDarkMode: isDarkMode,
          ),
          ContractDurationFilterWidget(
            isDarkMode: isDarkMode,
            selectedDuration: _selectedDurationEntity,
            onSelected: (duration) {
              setState(() {
                _selectedDurationEntity = duration;
              });
              context.read<HourlyContractCubit>().updateSelectedDuration(
                _selectedDurationEntity?.id,
              );
            },
          ),
          SizedBox(height: 20.h),

          // ✅ Delivery Notes
          DeliveryNotesWidget(isDarkMode: isDarkMode),
          SizedBox(height: 20.h),

          // ✅ Packages List
          SectionTitleWidget(
            title: LocaleKeys.packages.tr(),
            isDarkMode: isDarkMode,
          ),
          _buildPackagesList(isDarkMode),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildPackagesList(bool isDarkMode) {
    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      buildWhen: (previous, current) =>
      previous.packages != current.packages ||
          previous.selectedDuration != current.selectedDuration ||
          previous.selectedVisits != current.selectedVisits ||
          previous.selectedHoursNumber != current.selectedHoursNumber ||
          previous.selectedTimeSlotId != current.selectedTimeSlotId,
      builder: (context, state) {
        if (state.packages.status == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.packages.status == RequestStatus.error) {
          return Center(
            child: Text(state.packages.error ?? LocaleKeys.error_loading_packages.tr()),
          );
        }

        if (state.packages.data.isEmpty) {
          return Center(child: Text(LocaleKeys.no_packages_available.tr()));
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
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
                  _expandedPackageIndex = _expandedPackageIndex == index ? -1 : index;
                });
              },
              onSelect: () {
                setState(() {
                  _selectedPackage = package;
                });
                context.read<DynamicStepsCubit>().executeDynamicStep(
                  controller: widget.stepEntity.controller ?? '',
                  action: widget.stepEntity.action ?? '',
                  method: widget.stepEntity.httpMethod ?? 'POST',
                  queryParameters: {
                    "selectedPricingId": package.selectedHourlyPricingId,
                    "stepId": widget.stepEntity.stepId ?? "",
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Align(
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
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
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
    );
  }
}