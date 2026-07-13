import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/utils/request_status_enum.dart';
import '../../../domain/entities/time_slot_entity.dart';
import '../../cubit/hourly_contract_cubit.dart';
import '../../cubit/hourly_contract_state.dart';
import '../horizontal_filter_widget.dart';

class VisitTimeFilterWidget extends StatelessWidget {
  final bool isDarkMode;
  final TimeSlotEntity? selectedTimeSlot;
  final Function(TimeSlotEntity) onSelected;

  const VisitTimeFilterWidget({
    super.key,
    required this.isDarkMode,
    required this.selectedTimeSlot,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      buildWhen: (previous, current) =>
      previous.timeSlots.status != current.timeSlots.status ||
          previous.timeSlots.data != current.timeSlots.data,
      builder: (context, state) {
        if (state.timeSlots.status == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.timeSlots.data.isEmpty) {
          return Text(LocaleKeys.no_time_slots_available.tr());
        }

        if (selectedTimeSlot == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(state.timeSlots.data.first);
          });
        }

        final timeSlotValues = state.timeSlots.data.map((e) => e.value ?? '').toList();
        final currentTimeSlotValue = selectedTimeSlot?.value ??
            (state.timeSlots.data.isNotEmpty ? state.timeSlots.data.first.value ?? '' : '');

        return HorizontalFilterWidget(
          items: timeSlotValues,
          selectedValue: currentTimeSlotValue,
          isDarkMode: isDarkMode,
          onSelected: (val) {
            final entity = state.timeSlots.data.firstWhere((e) => e.value == val);
            onSelected(entity);
          },
        );
      },
    );
  }
}