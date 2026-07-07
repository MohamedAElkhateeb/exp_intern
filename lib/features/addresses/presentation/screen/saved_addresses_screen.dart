import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_state.dart';
import '../../domain/entities/address_entity.dart';
import '../cubit/addresses_cubit.dart';
import '../cubit/addresses_state.dart';
import '../widgets/address_item_widget.dart';

class SavedAddressesScreen extends StatefulWidget {
  final String serviceId;
  final DynamicStepEntity stepEntity;

  const SavedAddressesScreen({
    super.key,
    required this.serviceId,
    required this.stepEntity,
  });

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  int? _selectedAddressIndex;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _hasNavigated = false;

    final currentState = context.read<AddressesCubit>().state;
    if (!currentState.isAddressesSuccess ||
        currentState.addressEntity == null) {
      context.read<AddressesCubit>().fetchSavedAddresses(
        serviceId: widget.serviceId,
      );
    }
  }

  @override
  void dispose() {
    context.read<DynamicStepsCubit>().resetState();
    super.dispose();
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: isDarkMode ? ColorsManager.white : ColorsManager.black,
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: isDarkMode ? ColorsManager.black : ColorsManager.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
          onPressed: () {
            context.read<DynamicStepsCubit>().resetState();
            Navigator.pop(context);
          },
        ),
        title: Text(
          LocaleKeys.select_address.tr(),
          style: textTheme.displayLarge?.copyWith(
            fontSize: 20.sp,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              size: 32.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: BlocListener<DynamicStepsCubit, DynamicStepsState>(
          listener: (context, dynamicState) {
            if (dynamicState.isSubmitSuccess) {
              final nextStep = dynamicState.stepEntity;

              context.read<DynamicStepsCubit>().resetState();
              Navigator.pushNamed(
                context,
                nextStep!.name!,
                arguments: {
                  'serviceId': widget.serviceId,
                  'stepEntity': nextStep ,
                },
              );
            }

            if (dynamicState.isSubmitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(dynamicState.failure?.message ?? LocaleKeys.something_went_wrong.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<AddressesCubit, AddressesState>(
            builder: (context, state) {
              if (state.isAddressesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorsManager.black),
                );
              }

              if (state.isAddressesError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.failure?.message ??
                              LocaleKeys.fetch_addresses_error.tr(),
                          style: textTheme.displayMedium?.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => context
                              .read<AddressesCubit>()
                              .fetchSavedAddresses(serviceId: widget.serviceId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? ColorsManager.white
                                : ColorsManager.black,
                          ),
                          child: Text(
                            LocaleKeys.retry.tr(),
                            style: TextStyle(
                              color: isDarkMode
                                  ? ColorsManager.black
                                  : ColorsManager.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.isAddressesSuccess && state.addressEntity != null) {
                final List<LocationItemEntity> allAddresses = [];

                if (state.addressEntity!.mainLocation != null) {
                  allAddresses.add(state.addressEntity!.mainLocation!);
                }
                if (state.addressEntity!.subLocations != null) {
                  allAddresses.addAll(state.addressEntity!.subLocations!);
                }

                if (allAddresses.isEmpty) {
                  return Center(
                    child: Text(
                      LocaleKeys.no_saved_addresses.tr(),
                      style: textTheme.displayMedium,
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        LocaleKeys.select_address_from_saved.tr(),
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? ColorsManager.white70
                              : ColorsManager.black,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Expanded(
                        child: ListView.separated(
                          itemCount: allAddresses.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = allAddresses[index];

                            return AddressItemWidget(
                              address: item.displayValue ?? '',
                              isSelected: _selectedAddressIndex == index,
                              isAvailable: item.availableForHourly ?? true,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                setState(() {
                                  _selectedAddressIndex = index;
                                  _hasNavigated = false;
                                });

                                context
                                    .read<DynamicStepsCubit>()
                                    .executeDynamicStep(
                                      controller:
                                          widget.stepEntity.controller ??
                                          '',
                                      action:
                                          widget.stepEntity.action ?? '',
                                      method:
                                          widget.stepEntity.httpMethod ??
                                          'POST',
                                      queryParameters: {
                                        "selectedLocationId": item.id,
                                        "hourlyServiceId": widget.serviceId,
                                        "stepId":
                                            widget.stepEntity.stepId ?? "",
                                      },
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
