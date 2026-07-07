// features/home/presentation/widgets/home_header.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.menu,
                size: 28.sp,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${LocaleKeys.welcome_greeting.tr()}${LocaleKeys.dear_customer.tr()}',
            style: textTheme.displayLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),          ),
          const Spacer(),
          Icon(
            Icons.notifications,
            size: 30.sp,
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
          ),
        ],
      ),
    );
  }
}