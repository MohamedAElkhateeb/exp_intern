import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class LanguageSwitchRow extends StatelessWidget {
  const LanguageSwitchRow({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.lang_en.tr(), style: LightAppStyle.bodyText),
        SizedBox(width: 8.w),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: isArabic,
            onChanged: (bool value) async {
              Locale newLocale = value ? const Locale('ar') : const Locale('en');
              await context.setLocale(newLocale);
            },
            activeColor: ColorsManager.black,
            activeTrackColor: ColorsManager.greyBorder.withOpacity(0.5),
            inactiveThumbColor: ColorsManager.black,
            inactiveTrackColor: ColorsManager.greyBorder.withOpacity(0.5),
          ),
        ),
        SizedBox(width: 8.w),
        Text(LocaleKeys.lang_ar.tr(), style: LightAppStyle.bodyText),
      ],
    );
  }
}