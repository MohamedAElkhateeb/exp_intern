import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        selectedItemColor: ColorsManager.primaryTeal,
        unselectedItemColor: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
        selectedLabelStyle: textTheme.displayMedium?.copyWith(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.displayMedium?.copyWith(
          fontSize: 11.sp,
        ),
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 22.sp),
            activeIcon: Icon(Icons.home, size: 22.sp),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined, size: 22.sp),
            activeIcon: Icon(Icons.description, size: 22.sp),
            label: LocaleKeys.contracts.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, size: 22.sp),
            activeIcon: Icon(Icons.shopping_bag, size: 22.sp),
            label: LocaleKeys.requests.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined, size: 22.sp),
            activeIcon: Icon(Icons.local_offer, size: 22.sp),
            label: LocaleKeys.offers.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_outlined, size: 22.sp),
            activeIcon: Icon(Icons.phone, size: 22.sp),
            label: LocaleKeys.contact_us.tr(),
          ),
        ],
      ),
    );
  }
}