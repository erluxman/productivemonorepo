import 'dart:io' show Platform;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/splash/splash_screen.dart';

void main() {
  // Enable Flutter scrolling on desktop platforms
  WidgetsFlutterBinding.ensureInitialized();

  // Set scroll behavior for desktop platforms
  GestureBinding.instance.resamplingEnabled = true;

  runApp(
    const ProviderScope(
      child: ProductiveApp(),
    ),
  );
}

class ProductiveApp extends ConsumerWidget {
  const ProductiveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Productive App',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, // Use the theme mode from the provider
      home: const SplashScreen(),
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
    // Use a more responsive and smoother scrolling physics
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
    // Add scrollbars for better desktop experience
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
