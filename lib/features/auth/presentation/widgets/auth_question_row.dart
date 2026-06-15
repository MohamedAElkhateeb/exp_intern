import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';

class AuthQuestionRow extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthQuestionRow({
    super.key,
    required this.question,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: LightAppStyle.bodyText.copyWith(
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: LightAppStyle.linkText,
          ),
        ),
      ],
    );
  }
}