// features/home/presentation/widgets/contact_us_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class ContactUsHomeScreen extends StatelessWidget {
  const ContactUsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.contact_us_message.tr(),
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? ColorsManager.white80 : ColorsManager.black.withOpacity(0.7),
            ),          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(FontAwesomeIcons.whatsapp, isDarkMode),
              _buildSocialIcon(FontAwesomeIcons.xTwitter, isDarkMode),
              _buildSocialIcon(FontAwesomeIcons.linkedinIn, isDarkMode),
              _buildSocialIcon(FontAwesomeIcons.instagram, isDarkMode),
              _buildSocialIcon(FontAwesomeIcons.facebookF, isDarkMode),
              _buildSocialIcon(FontAwesomeIcons.tiktok, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, bool isDarkMode) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: isDarkMode ? ColorsManager.white70 : const Color(0xFFBCBCBC),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: FaIcon(
          icon,
          size: 16.sp,
          color: ColorsManager.white,
        ),
      ),
    );
  }
}