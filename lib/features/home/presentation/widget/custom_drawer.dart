import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final themeCubit = context.watch<ThemeCubit>();

    return Drawer(
      child: Container(
        color: isDarkMode ? ColorsManager.darkBackground : ColorsManager.white,
        child: Column(
          children: [
            _buildDrawerHeader(isDarkMode, textTheme),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                children: [
                  _buildDrawerItem(
                    title: LocaleKeys.dashboard.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.notifications.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.contracts.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.my_requests.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.individual_requests.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.my_visits.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.support_tickets.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.contact_us.tr(),
                    onTap: () => Navigator.pop(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.english.tr(),
                    onTap: () => _showLanguageDialog(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                  _buildDrawerItem(
                    title: LocaleKeys.logout.tr(),
                    isLogout: true,
                    onTap: () => _showLogoutDialog(context),
                    isDarkMode: isDarkMode,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
            _buildDarkModeToggle(context, themeCubit, isDarkMode, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(bool isDarkMode, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, left: 24.w, right: 24.w, bottom: 16.h),
      color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'محمد مصطفى',
              style: textTheme.displayLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDarkMode ? ColorsManager.darkCard : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 18.sp,
                  color: isDarkMode ? ColorsManager.white70 : ColorsManager.black.withOpacity(0.7),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${LocaleKeys.wallet_balance.tr()} 80,228.58 ${LocaleKeys.sar.tr()}',
                  style: textTheme.displayMedium?.copyWith(
                    fontSize: 13.sp,
                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    required bool isDarkMode,
    required TextTheme textTheme,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          fontSize: 15.sp,
          color: isLogout
              ? ColorsManager.error
              : (isDarkMode ? ColorsManager.white80 : ColorsManager.black.withOpacity(0.8)),
          fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDarkModeToggle(
      BuildContext context,
      ThemeCubit themeCubit,
      bool isDarkMode,
      TextTheme textTheme,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF9F9F9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            LocaleKeys.dark_mode.tr(),
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              themeCubit.toggleTheme();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60.w,
              height: 32.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                color: isDarkMode ? ColorsManager.primaryTeal : ColorsManager.greyLight,
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsManager.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4.r,
                          ),
                        ],
                      ),
                      child: Icon(
                        isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                        size: 18.sp,
                        color: isDarkMode ? ColorsManager.primaryTeal : ColorsManager.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
          title: Text(
            LocaleKeys.logout.tr(),
            style: TextStyle(color: isDarkMode ? ColorsManager.white : ColorsManager.black),
          ),
          content: Text(
            LocaleKeys.logout_confirmation.tr(),
            style: TextStyle(color: isDarkMode ? ColorsManager.white80 : ColorsManager.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                LocaleKeys.cancel.tr(),
                style: TextStyle(color: isDarkMode ? ColorsManager.white70 : ColorsManager.primaryTeal),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/logIn',
                      (route) => false,
                );
              },
              child: Text(
                LocaleKeys.logout.tr(),
                style: const TextStyle(color: ColorsManager.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
  }
}