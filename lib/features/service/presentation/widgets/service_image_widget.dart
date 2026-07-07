import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';

class ServiceImageWidget extends StatelessWidget {
  final String? url;
  final bool isDarkMode;
  final double size;

  const ServiceImageWidget({
    super.key,
    required this.url,
    required this.isDarkMode,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50.sp,
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        url!,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 50.sp,
              color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: size.w,
            height: size.h,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}