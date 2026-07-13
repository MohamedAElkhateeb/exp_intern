import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/utils/request_status_enum.dart';
import '../../../domain/entities/shift_entity.dart';
import '../../cubit/hourly_contract_cubit.dart';
import '../../cubit/hourly_contract_state.dart';
import '../horizontal_filter_widget.dart';

class ShiftFilterWidget extends StatelessWidget {
  final bool isDarkMode;
  final String serviceId;
  final ShiftEntity? selectedShift;
  final Function(ShiftEntity) onSelected;

  const ShiftFilterWidget({
    super.key,
    required this.isDarkMode,
    required this.serviceId,
    required this.selectedShift,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      buildWhen: (previous, current) =>
      previous.shifts.status != current.shifts.status ||
          previous.shifts.data != current.shifts.data,
      builder: (context, state) {
        if (state.shifts.status == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.shifts.data.isEmpty) {
          return Text(LocaleKeys.no_shifts_available.tr());
        }

        // ✅ تحديد أول قيمة تلقائياً
        if (selectedShift == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(state.shifts.data.first);
          });
        }

        final shiftNames = state.shifts.data.map((e) => e.name ?? '').toList();
        final currentShiftName = selectedShift?.name ??
            (state.shifts.data.isNotEmpty ? state.shifts.data.first.name ?? '' : '');

        return HorizontalFilterWidget(
          items: shiftNames,
          selectedValue: currentShiftName,
          isDarkMode: isDarkMode,
          fixedWidth: 100.w,
          onSelected: (name) {
            final entity = state.shifts.data.firstWhere((e) => e.name == name);
            onSelected(entity);
          },
        );
      },
    );
  }
}