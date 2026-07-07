import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../domain/entity/service_entity.dart';

class ServiceDialog extends StatelessWidget {
  final ServiceEntity service;
  final bool isDarkMode;
  final BuildContext parentContext;
  final int serviceType;
  final String serviceId;

  const ServiceDialog({
    super.key,
    required this.service,
    required this.isDarkMode,
    required this.parentContext,
    required this.serviceType,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return AlertDialog(
      backgroundColor: isDarkMode
          ? ColorsManager.darkSurface
          : ColorsManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      contentPadding: EdgeInsets.all(30.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber, size: 60.sp, color: Colors.amber),
          SizedBox(height: 15.h),
          Text(
            service.description,
            style: LightAppStyle.title.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          if (service.serviceNote != null &&
              service.serviceNote!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              service.serviceNote!,
              style: textTheme.displayMedium?.copyWith(
                fontSize: 14.sp,
                color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(
                      color: isDarkMode
                          ? ColorsManager.white70
                          : ColorsManager.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.cancel.tr(),
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? ColorsManager.white
                          : ColorsManager.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    parentContext.read<DynamicStepsCubit>().fetchFirstStep(
                      serviceType: serviceType,
                      serviceId: serviceId
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? ColorsManager.white
                        : ColorsManager.black,
                    foregroundColor: isDarkMode
                        ? ColorsManager.black
                        : ColorsManager.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.select.tr(),
                    style: LightAppStyle.labelStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? ColorsManager.black
                          : ColorsManager.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
