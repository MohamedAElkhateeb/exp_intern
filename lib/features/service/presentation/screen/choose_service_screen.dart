import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_state.dart';
import '../../../home/presentation/widget/service_card.dart';
import '../cubit/service_cubit.dart';
import '../cubit/service_state.dart';
import '../../domain/entity/service_entity.dart';
import '../widgets/service_dialog.dart';
import '../widgets/service_image_widget.dart';

class ChooseServiceScreen extends StatefulWidget {
  final int serviceType;

  const ChooseServiceScreen({super.key, required this.serviceType,});

  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceCubit>().getServices(serviceType: widget.serviceType);
  }

  String? selectedServiceId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return BlocListener<DynamicStepsCubit, DynamicStepsState>(
      listener: (context, state) {
        // 👇 مراقبة حالة الـ fetch
        if (state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: ColorsManager.white),
            ),
          );
        } else if (state.isError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.failure?.message ?? LocaleKeys.something_went_wrong.tr(),
              ),
            ),
          );
        } else if (state.isSuccess) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            RoutesManager.savedAddresses,
            arguments: {
              'serviceId': selectedServiceId,
              'firstStepEntity': state.stepEntity,
            },
          );
          // 👈 إعادة تعيين الحالة بعد التنقل
          context.read<DynamicStepsCubit>().resetState();
        }

        // 👇 مراقبة حالة الـ submit (دي بتاعة الديالوج)
        if (state.isSubmitLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: ColorsManager.white),
            ),
          );
        } else if (state.isSubmitError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.failure?.message ?? LocaleKeys.something_went_wrong.tr(),
              ),
            ),
          );
        } else if (state.isSubmitSuccess) {
          Navigator.pop(context);
          // التعامل مع نجاح الـ submit هنا لو احتاجيت
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? ColorsManager.darkBackground
            : ColorsManager.white,
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? ColorsManager.darkBackground
              : ColorsManager.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.choose_service.tr(),
            style: textTheme.displayLarge?.copyWith(
              fontSize: 20.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
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
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Text(
                  LocaleKeys.select_required_service.tr(),
                  style: textTheme.displayMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? ColorsManager.white
                        : ColorsManager.black,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, state) {
                    if (state is ServiceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ServiceError) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            state.failure.message ??
                                LocaleKeys.something_went_wrong_try_again.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDarkMode
                                  ? ColorsManager.white
                                  : ColorsManager.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      );
                    } else if (state is ServiceSuccess) {
                      final services = state.services;

                      if (services.isEmpty) {
                        return Center(
                          child: Text(
                            LocaleKeys.no_services_available.tr(),
                            style: TextStyle(
                              color: isDarkMode
                                  ? ColorsManager.white
                                  : ColorsManager.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView.separated(
                          itemCount: services.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return ServiceCard(
                              title: service.title,
                              subtitle: service.description,
                              iconWidget: ServiceImageWidget(
                                url: service.iconUrl,
                                isDarkMode: isDarkMode,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedServiceId = service.id;
                                });
                                if (service.serviceNote == null ||
                                    service.serviceNote!.trim().isEmpty) {
                                  context
                                      .read<DynamicStepsCubit>()
                                      .fetchFirstStep(
                                    serviceType: widget.serviceType,
                                    serviceId: selectedServiceId ??'',
                                  );
                                } else {
                                  _openServiceDialog(
                                    context,
                                    service,
                                    isDarkMode,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openServiceDialog(
      BuildContext context,
      ServiceEntity service,
      bool isDarkMode,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ServiceDialog(
          serviceType: widget.serviceType,
          serviceId: selectedServiceId??'',
          service: service,
          isDarkMode: isDarkMode,
          parentContext: context,
        );
      },
    );
  }
}