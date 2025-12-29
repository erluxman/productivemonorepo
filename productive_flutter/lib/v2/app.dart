import 'dart:io' show Platform;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/home/home_screen.dart';
import 'features/splash/splash_screen.dart';
import 'core/auth/providers/auth_provider.dart';

class ProductiveApp extends ConsumerWidget {
  const ProductiveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Productive App',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: authState.when(
        data: (user) =>
            user != null ? const HomeScreen() : const SplashScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => const SplashScreen(),
      ),
    );
  }
}

// Custom scroll behavior to support mouse dragging
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux
        ? Scrollbar(
            controller: details.controller,
            thumbVisibility: true,
            thickness: 6.0,
            radius: const Radius.circular(10.0),
            child: child,
          )
        : child;
  }
}

