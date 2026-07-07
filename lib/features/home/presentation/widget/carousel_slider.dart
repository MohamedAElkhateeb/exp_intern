import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class CustomCarousel extends StatefulWidget {
  final double? height;
  final bool autoPlay;
  final bool showIndicator;

  const CustomCarousel({
    super.key,
    this.height,
    this.autoPlay = false,
    this.showIndicator = true,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _items = [
    {
      'icon': Icons.picture_in_picture,
      'title': LocaleKeys.custom_design_for_offers.tr(),
      'subtitle': LocaleKeys.special_offer.tr(),
    },
    {
      'icon': Icons.picture_in_picture,
      'title': LocaleKeys.custom_design_for_offers.tr(),
      'subtitle': LocaleKeys.special_offer.tr(),
    },
    {
      'icon': Icons.picture_in_picture,
      'title': LocaleKeys.custom_design_for_offers.tr(),
      'subtitle': LocaleKeys.special_offer.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height ?? 200.h,
            viewportFraction: 0.94,
            autoPlay: widget.autoPlay,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _items.map((item) => _buildSlide(item, isDarkMode)).toList(),
        ),
        if (widget.showIndicator)
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: _buildIndicator(isDarkMode),
          ),
      ],
    );
  }

  Widget _buildSlide(Map<String, dynamic> item, bool isDarkMode) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Container(
      margin: EdgeInsets.all(5.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkCard : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item['icon'],
            size: 40.sp,
            color: isDarkMode
                ? ColorsManager.white70
                : ColorsManager.greyBorder,
          ),
          SizedBox(height: 16.h),
          Text(
            item['title'],
            style: textTheme.displayLarge?.copyWith(
              fontSize: 16.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            item['subtitle'],
            style: textTheme.displayMedium?.copyWith(
              color: isDarkMode
                  ? ColorsManager.white70
                  : ColorsManager.greyText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_items.length, (index) {
        return Container(
          width: 12.w,
          height: 12.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? (isDarkMode
                      ? ColorsManager.primaryTeal
                      : ColorsManager.greyBorder)
                : (isDarkMode
                      ? ColorsManager.white70.withOpacity(0.3)
                      : ColorsManager.greyBorder.withOpacity(0.3)),
          ),
        );
      }),
    );
  }
}
