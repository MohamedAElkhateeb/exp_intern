// features/home/presentation/widgets/services_section.dart
import 'package:exp_intern/core/utils/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import 'service_card.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.featured_services.tr(),
            style: LightAppStyle.title.copyWith(
              fontSize: 22.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.indispensable_services.tr(),
            style: LightAppStyle.subtitle.copyWith(
              fontSize: 14.sp,
              color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
            ),
          ),
          SizedBox(height: 24.h),
          ServiceCard(
            icon: Icons.access_time_outlined,
            title: LocaleKeys.hourly_service.tr(),
            subtitle: LocaleKeys.hourly_service_desc.tr(),
          ),
          SizedBox(height: 16.h),
          ServiceCard(
            icon: Icons.calendar_today_outlined,
            title: LocaleKeys.residential_service.tr(),
            subtitle: LocaleKeys.residential_service_desc.tr(),
          ),
        ],
      ),
    );
  }
}