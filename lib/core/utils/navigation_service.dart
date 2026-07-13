import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static OverlayState? get overlay => navigatorKey.currentState?.overlay;

  static void showSnackBar(String message, {Color? color}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color ?? Colors.green,
        ),
      );
    }
  }
}