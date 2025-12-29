import 'dart:ui';

import 'package:flutter/material.dart';

/// A custom page route for dialogs with smoother transitions
class DialogRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final bool useBlurBackground;

  DialogRoute({
    required this.child,
    this.useBlurBackground = false,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          barrierDismissible: true,
          barrierColor: Colors.black.withAlpha(128),
          transitionDuration: const Duration(milliseconds: 300),
          opaque: false,
        );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return useBlurBackground
        ? _BlurDialogBackground(
            child: child,
          )
        : child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Define custom animations with faster curves
    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );

    final Animation<double> scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(scaleAnimation),
        child: child,
      ),
    );
  }
}

/// A widget that adds a blur background to dialogs
class _BlurDialogBackground extends StatelessWidget {
  final Widget child;

  const _BlurDialogBackground({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withAlpha(51),
        child: child,
      ),
    );
  }
}

/// Shows a dialog using the custom route
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useBlurBackground = false,
}) {
  return Navigator.of(context).push(
    DialogRoute<T>(
      child: builder(context),
      useBlurBackground: useBlurBackground,
    ),
  );
}

