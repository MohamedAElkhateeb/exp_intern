import 'package:exp_intern/core/utils/locale_keys.g.dart';
import 'package:exp_intern/features/home/presentation/widget/contact_us_home_screen.dart';
import 'package:flutter/material.dart' hide Slider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/carousel_slider.dart';
import '../widget/custom_drawer.dart';
import '../widget/home_header.dart';
import '../widget/services_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const _HomeContent(),
      const _PlaceholderScreen(title: LocaleKeys.contracts),
      const _PlaceholderScreen(title: LocaleKeys.requests),
      const _PlaceholderScreen(title: LocaleKeys.offers),
      const _PlaceholderScreen(title: LocaleKeys.contact_us),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(bottom: false, child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 24.h),
                const CustomCarousel(),
                const ServicesSection(),
                SizedBox(height: 5.h),
                const ContactUsHomeScreen(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return Center(
      child: Text(
        title.tr(),
        style: textTheme.displayLarge?.copyWith(
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),      ),
    );
  }
}