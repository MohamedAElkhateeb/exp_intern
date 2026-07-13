import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/utils/request_status_enum.dart';
import '../../../../resource_groub/domain/entities/nationality_entity.dart';
import '../../../../resource_groub/presentation/cubit/resource_group_cubit.dart';
import '../../../../resource_groub/presentation/cubit/resource_group_state.dart';
import '../horizontal_filter_widget.dart';

class NationalityFilterWidget extends StatelessWidget {
  final bool isDarkMode;
  final NationalityEntity? selectedNationality;
  final Function(NationalityEntity) onSelected;

  const NationalityFilterWidget({
    super.key,
    required this.isDarkMode,
    required this.selectedNationality,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceGroupCubit, ResourceGroupState>(
      buildWhen: (previous, current) =>
      previous.resourceGroups != current.resourceGroups ||
          previous.resourceGroupsStatus != current.resourceGroupsStatus,
      builder: (context, state) {
        if (state.resourceGroupsStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.resourceGroupsStatus == RequestStatus.error) {
          return Text(state.errorMessage ?? LocaleKeys.error_loading_nationalities.tr());
        }

        if (state.resourceGroups.isEmpty) {
          return Text(LocaleKeys.no_nationalities_available.tr());
        }

        // ✅ تحديد أول قيمة تلقائياً
        if (selectedNationality == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(state.resourceGroups.first);
          });
        }

        final nationalityNames = state.resourceGroups.map((e) => e.name as String).toList();
        final currentName = selectedNationality?.name ??
            (state.resourceGroups.isNotEmpty ? state.resourceGroups.first.name as String : '');

        return HorizontalFilterWidget(
          items: nationalityNames,
          selectedValue: currentName,
          isDarkMode: isDarkMode,
          onSelected: (name) {
            final entity = state.resourceGroups.firstWhere((e) => e.name == name);
            onSelected(entity);
          },
        );
      },
    );
  }
}