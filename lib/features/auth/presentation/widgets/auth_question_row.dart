import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_styles.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: LightAppStyle.bodyText),
        GestureDetector(
          onTap: onActionTap,
          child: Text(actionText, style: LightAppStyle.linkText),
        ),
      ],
    );
  }
}