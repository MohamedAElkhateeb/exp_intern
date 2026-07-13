import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/utils/request_status_enum.dart';
import '../../../domain/entities/contract_duration_entity.dart';
import '../../cubit/hourly_contract_cubit.dart';
import '../../cubit/hourly_contract_state.dart';
import '../horizontal_filter_widget.dart';

class ContractDurationFilterWidget extends StatelessWidget {
  final bool isDarkMode;
  final ContractDurationEntity? selectedDuration;
  final Function(ContractDurationEntity) onSelected;

  const ContractDurationFilterWidget({
    super.key,
    required this.isDarkMode,
    required this.selectedDuration,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      buildWhen: (previous, current) =>
      previous.durations.status != current.durations.status ||
          previous.durations.data != current.durations.data,
      builder: (context, state) {
        if (state.durations.status == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.durations.data.isEmpty) {
          return Text(LocaleKeys.no_durations_available.tr());
        }

        if (selectedDuration == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(state.durations.data.first);
          });
        }

        final durationValues = state.durations.data.map((e) => e.value ?? '').toList();
        final currentDurationValue = selectedDuration?.value ??
            (state.durations.data.isNotEmpty ? state.durations.data.first.value ?? '' : '');

        return HorizontalFilterWidget(
          items: durationValues,
          selectedValue: currentDurationValue,
          isDarkMode: isDarkMode,
          onSelected: (val) {
            final entity = state.durations.data.firstWhere((e) => e.value == val);
            onSelected(entity);
          },
        );
      },
    );
  }
}