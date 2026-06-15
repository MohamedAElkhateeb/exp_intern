import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/utils/routes_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            buildWhen: (previous, current) => current is ThemeChanged,
            builder: (context, state) {
              final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

              return MaterialApp(
                title: 'My App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                onGenerateRoute: RoutesManager.router,
                onUnknownRoute: (_) => MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    body: Center(
                      child: Text("Page not found"),
                    ),
                  ),
                ),
                initialRoute: RoutesManager.logIn,
              );
            },
          );
        },
      ),
    );
  }
}