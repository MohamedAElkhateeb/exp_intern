import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          LocaleKeys.byCompletingSteps.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () {},
          child: Text(
            LocaleKeys.companyTerms.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryTeal,
            ),
          ),
        ),
      ],
    );
  }
}