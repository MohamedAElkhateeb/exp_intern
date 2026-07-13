import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/utils/request_status_enum.dart';
import '../../../domain/entities/shift_hours_entity.dart';
import '../../cubit/hourly_contract_cubit.dart';
import '../../cubit/hourly_contract_state.dart';
import '../horizontal_filter_widget.dart';

class VisitDurationFilterWidget extends StatelessWidget {
  final bool isDarkMode;
  final ShiftHoursEntity? selectedHour;
  final Function(ShiftHoursEntity) onSelected;

  const VisitDurationFilterWidget({
    super.key,
    required this.isDarkMode,
    required this.selectedHour,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      buildWhen: (previous, current) =>
      previous.shiftHours.status != current.shiftHours.status ||
          previous.shiftHours.data != current.shiftHours.data,
      builder: (context, state) {
        if (state.shiftHours.status == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.shiftHours.data.isEmpty) {
          return Text(LocaleKeys.no_shift_hours_available.tr());
        }

        if (selectedHour == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(state.shiftHours.data.first);
          });
        }

        final hourValues = state.shiftHours.data.map((e) => e.value ?? '').toList();
        final currentHourValue = selectedHour?.value ??
            (state.shiftHours.data.isNotEmpty ? state.shiftHours.data.first.value ?? '' : '');

        return HorizontalFilterWidget(
          items: hourValues,
          selectedValue: currentHourValue,
          isDarkMode: isDarkMode,
          onSelected: (val) {
            final entity = state.shiftHours.data.firstWhere((e) => e.value == val);
            onSelected(entity);
          },
        );
      },
    );
  }
}