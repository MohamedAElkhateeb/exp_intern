import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/utils/endpoint_manager.dart';
import 'core/utils/navigation_service.dart';
import 'core/utils/routes_manager.dart';
import 'core/widgets/request_inspector.dart';
import 'features/dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _themeCubit = ThemeCubit();

    // ✅ تحميل الثيم بعد ما التطبيق يخلص بناء أول فريم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeCubit.loadSavedTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    EndpointsManager.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<DynamicStepsCubit>()),
        // ✅ استخدم الـ ThemeCubit الموجود بدل إنشاء جديد
        BlocProvider.value(value: _themeCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          // ✅ استخدم BlocSelector بدلاً من BlocBuilder
          return BlocSelector<ThemeCubit, ThemeState, bool>(
            selector: (state) {
              if (state is ThemeChanged) return state.isDarkMode;
              return false; // القيمة الافتراضية
            },
            builder: (context, isDarkMode) {
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
                navigatorKey: NavigationService.navigatorKey,
                onUnknownRoute: (_) => MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    body: Center(
                      child: Text("Page not found"),
                    ),
                  ),
                ),
                initialRoute: RoutesManager.logIn,
                builder: (context, child) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        child!,
                        Positioned(
                          bottom: 80.h,
                          right: 24.w,
                          child: const RequestInspector(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}