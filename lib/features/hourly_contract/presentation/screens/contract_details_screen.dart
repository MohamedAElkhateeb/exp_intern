import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_state.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/action_buttons_widget.dart';
import '../widgets/coupon_section.dart';
import '../widgets/package_card_widget.dart';
import '../widgets/preferred_days_section.dart';
import '../widgets/terms_and_conditions_widget.dart';

class ContractDetailsScreen extends StatefulWidget {
  const ContractDetailsScreen({super.key});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  final TextEditingController _couponController = TextEditingController();

  String? stepId;
  String? serviceId;
  SelectedPackageEntity? selectedPackage;
  Map<String, dynamic>? contractData;
  DynamicStepEntity? _stepDetailsEntity;
  String? _dynamicHourlyPricingId;

  List<String> selectedDays = [];
  bool _showMaxDaysMessage = false;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _couponController.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Execute only once
    if (!_isInitialized) {
      _isInitialized = true;

      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      stepId = args?['stepEntity']?.stepId ?? args?['stepId'] ?? '';
      serviceId = args?['serviceId'] ?? '';
      selectedPackage = args?['selectedPackage'];
      contractData = args?['contractData'] as Map<String, dynamic>?;
      _dynamicHourlyPricingId = selectedPackage?.selectedHourlyPricingId;

      // ✅ Use WidgetsBinding to ensure proper timing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (stepId?.isNotEmpty ?? false) {
          context.read<DynamicStepsCubit>().fetchStepDetailsByActionName(
            stepId: stepId!,
            actionName: 'HourlyPackagePromotion',
            serviceType: 2,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _updateSelectedDays(String date, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedDays.remove(date);
        _showMaxDaysMessage = false;
      } else {
        final maxDays = selectedPackage?.weeklyVisits ?? 1;
        if (selectedDays.length < maxDays) {
          selectedDays.add(date);
          _showMaxDaysMessage = false;
        } else {
          _showMaxDaysMessage = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                LocaleKeys.max_days_selected_message.tr(
                  namedArgs: {'maxDays': maxDays.toString()},
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<DynamicStepsCubit, DynamicStepsState>(
          listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent == true,
          listener: (context, state) {
            _handleDynamicStepsState(state, context);
          },
        ),
        BlocListener<HourlyContractCubit, HourlyContractState>(
          listener: (context, state) {
            _handleHourlyContractState(state);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme, isDarkMode),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CouponSection(
                controller: _couponController,
                onApplyCoupon: _applyCoupon,
              ),
              SizedBox(height: 20.h),
              BlocBuilder<HourlyContractCubit, HourlyContractState>(
                builder: (context, state) {
                  return PreferredDaysSection(
                    state: state,
                    selectedDays: selectedDays,
                    maxDays: selectedPackage?.weeklyVisits ?? 1,
                    isDarkMode: isDarkMode,
                    onDayTap: _updateSelectedDays,
                    showMaxDaysMessage: _showMaxDaysMessage,
                  );
                },
              ),
              SizedBox(height: 20.h),
              PackageCardWidget(
                selectedDays: selectedDays,
                selectedPackage: selectedPackage,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 24.h),
              const TermsAndConditionsWidget(),
              SizedBox(height: 24.h),
              BlocBuilder<HourlyContractCubit, HourlyContractState>(
                builder: (context, state) {
                  return ActionButtonsWidget(
                    selectedDays: selectedDays,
                    selectedPackage: selectedPackage,
                    stepId: stepId,
                    serviceId: serviceId,
                    contractData: contractData,
                    stepDetailsEntity: _stepDetailsEntity,
                    dynamicHourlyPricingId: _dynamicHourlyPricingId,
                    isDarkMode: isDarkMode,
                    onShowVisits: _showVisits,
                    onCompleteContract: _completeContract,
                    state: state,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ Helper Methods ============

  void _handleDynamicStepsState(DynamicStepsState state, BuildContext context) {
    if (state.isStepDetailsSuccess) {
      _stepDetailsEntity = state.stepDetailsEntity;
      if (selectedPackage != null && (stepId?.isNotEmpty ?? false)) {
        context.read<HourlyContractCubit>().fetchHourlyPricing(
          stepId: stepId!,
          data: {
            'selectedHourlyPricingId':
            selectedPackage!.selectedHourlyPricingId,
            'resourceGroupId': selectedPackage!.resourceGroupId,
            'serviceId': serviceId ?? '',
            'contractStartDate': contractData?['contractStartDate'] ?? '',
            'contractDuration':
            selectedPackage!.contractDuration.toString(),
            'hoursCount': selectedPackage!.hoursNumber.toString(),
            'empcount': selectedPackage!.employeeNumber.toString(),
            'weeklyvisits': selectedPackage!.weeklyVisits.toString(),
            'visitShift': selectedPackage!.visitShift.toString(),
            'promotionCode': selectedPackage!.promotionCode ?? '',
            'days': contractData?['days'] ?? '',
            'timeSlotId': selectedPackage!.timeSlotId,
          },
        );
      }
    }

    if (state.isStepDetailsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.stepDetailsFailure?.message ??
                LocaleKeys.something_went_wrong.tr(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    if (state.isSubmitSuccess) {
      final nextStep = state.stepEntity;
      if (nextStep != null) {
        if (nextStep.action == 'CreateContract') {
          context.read<DynamicStepsCubit>().resetState();
          context.read<DynamicStepsCubit>().executeDynamicStep(
            controller: nextStep.controller ?? 'HourlyContract',
            action: nextStep.action ?? 'CreateContract',
            method: nextStep.httpMethod ?? 'POST',
            queryParameters: {'stepId': stepId},
            data: null,
          );
        } else if (nextStep.action == 'ContractSuccessData') {
          Navigator.pushNamed(
            context,
            nextStep.name ?? 'SuccessScreen',
            arguments: {'stepEntity': nextStep},
          );
        }
      }
    }

    if (state.isSubmitError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.failure?.message ?? LocaleKeys.something_went_wrong.tr(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleHourlyContractState(HourlyContractState state) {
    if (state.hourlyPricingStatus == RequestStatus.success) {
      final firstPackage = state.hourlyPricingData?.hourlyPackages.firstOrNull;
      if (firstPackage != null && firstPackage.hourlypricingId != null) {
        setState(() {
          _dynamicHourlyPricingId = firstPackage.hourlypricingId;
        });
      }
    }

    if (state.hourlyPricingStatus == RequestStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.hourlyPricingError ?? LocaleKeys.error_loading_pricing.tr(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _applyCoupon() {
    if (_couponController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.coupon_applied_successfully.tr()),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showVisits() {
    if (selectedDays.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.selected_days_list.tr(
              namedArgs: {'days': selectedDays.join(', ')},
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.please_select_days_first.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _completeContract(
      BuildContext context,
      HourlyContractState state,
      ) {
    final stepEntity = _stepDetailsEntity;
    if (stepEntity != null) {
      // نفس الـ logic القديم بالضبط
      final List<String> selectedDayNames = [];
      for (var date in selectedDays) {
        final matchingDay = state.availableDays.data.cast<dynamic>().firstWhere(
              (element) => element.date == date,
          orElse: () => null,
        );
        if (matchingDay != null) {
          selectedDayNames.add(matchingDay.dayName);
        } else if (state.availableDays.data.isNotEmpty) {
          selectedDayNames.add(state.availableDays.data.first.dayName);
        }
      }

      final daysNamesString = selectedDayNames.join(',');

      context.read<DynamicStepsCubit>().executeDynamicStep(
        controller: stepEntity.controller ?? '',
        action: stepEntity.action ?? '',
        method: stepEntity.httpMethod ?? 'POST',
        queryParameters: {'stepId': stepId},
        data: {
          'hourlyPricingId': _dynamicHourlyPricingId,
          'resourceGroupId': selectedPackage!.resourceGroupId,
          'serviceId': serviceId ?? '',
          'contractDuration': selectedPackage!.contractDuration.toString(),
          'hoursCount': selectedPackage!.hoursNumber.toString(),
          'timeSlotId': selectedPackage!.timeSlotId,
          'empcount': selectedPackage!.employeeNumber.toString(),
          'weeklyvisits': selectedPackage!.weeklyVisits.toString(),
          'visitShift': selectedPackage!.visitShift.toString(),
          'promotionCode': selectedPackage!.promotionCode ?? '',
          'days': daysNamesString,
          'startDate': contractData?['contractStartDate'] ?? '',
          'extraVisits': '0',
          'isQuestionerDone': true,
          'newShiftEndDate': null,
          'newShiftStartDate': null,
          'ContactPerson': null,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري تحميل تفاصيل الخطوة...'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        LocaleKeys.contractDetails.tr(),
        style: theme.textTheme.displayLarge?.copyWith(
          fontSize: 20.sp,
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, size: 28.sp),
          onPressed: () {},
        ),
      ],
    );
  }
}