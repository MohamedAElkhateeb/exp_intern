import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';

class SuccessIconWidget extends StatelessWidget {
  const SuccessIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.check_circle_outline_rounded,
        color: ColorsManager.black,
        size: 110.sp,
      ),
    );
  }
}