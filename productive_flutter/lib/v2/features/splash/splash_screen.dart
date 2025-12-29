import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:productive_flutter/v2/features/auth/login_screen.dart';
import 'package:productive_flutter/v2/features/auth/signup_screen.dart';
import 'package:productive_flutter/v2/features/home/home_screen.dart';
import 'package:productive_flutter/v2/features/splash/widgets/login_button.dart';
import 'package:productive_flutter/v2/core/navigation/navigation_extension.dart';
import 'package:productive_flutter/v2/core/ui/fade_page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToReplacing(
      BuildContext context, Widget destination) async {
    _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;
    await Navigator.pushReplacement(
      context,
      FadePageTransition(page: destination),
    );
  }

  Future<void> _navigateToLoginWithPaperPlane(BuildContext context) async {
    // Special transition for paper plane animation
    await _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!context.mounted) return;
    context.navigateToReplacing(const LoginScreen()).then((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Future<void> _navigateTo(BuildContext context, Widget destination) async {
    await _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    await Navigator.push(
      context,
      FadePageTransition(page: destination),
    ).then((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'paper_plane_animation',
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  // Use a curved animation for smoother transitions
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: flightDirection == HeroFlightDirection.push
                        ? Curves.easeOutQuad
                        : Curves.easeInOutCubic,
                  );

                  return AnimatedBuilder(
                    animation: curvedAnimation,
                    builder: (context, child) {
                      // Different rotation and sizing logic based on direction
                      final rotationAngle =
                          flightDirection == HeroFlightDirection.push
                              ? curvedAnimation.value * 0.15
                              : (1 - curvedAnimation.value) * 0.15;

                      final heightAdjustment =
                          flightDirection == HeroFlightDirection.push
                              ? 300 - (curvedAnimation.value * 50)
                              : 250 + (curvedAnimation.value * 50);

                      return Transform.rotate(
                        angle: rotationAngle,
                        child: Lottie.asset(
                          'assets/lottie/paper_plane.json',
                          height: heightAdjustment,
                          width: heightAdjustment,
                          animate: true,
                          repeat: true,
                          frameRate: FrameRate.max,
                        ),
                      );
                    },
                  );
                },
                placeholderBuilder: (context, size, widget) {
                  return const Opacity(
                    opacity: 0,
                    child: SizedBox(
                      height: 300,
                      width: 300,
                    ),
                  );
                },
                child: Lottie.asset(
                  'assets/lottie/paper_plane.json',
                  height: 300,
                  width: 300,
                  repeat: true,
                ),
              ),
            ],
          ),
          const Spacer(flex: 3),
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bound) {
              return const LinearGradient(
                colors: [
                  Color(0xFF01A4FF),
                  Color(0xFF0196FF),
                ],
                begin: Alignment(-1.0, -0.7),
                end: Alignment(-0.7, 1.0),
                transform: GradientRotation(-pi / 2),
              ).createShader(bound);
            },
            child: const Text(
              "Productive\nFriends",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 64,
              ),
            ),
          ),
          const Spacer(flex: 5),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - _animation.value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                const Text(
                  "Continue with",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginButton(
                      onPressed: () =>
                          _navigateToReplacing(context, const HomeScreen()),
                      icon: SvgPicture.asset(
                        "assets/images/google.svg",
                        width: 24,
                      ),
                      heroTag: 'google_login_button',
                    ),
                    const SizedBox(width: 24),
                    LoginButton(
                      onPressed: () =>
                          _navigateToReplacing(context, const HomeScreen()),
                      icon: SvgPicture.asset(
                        "assets/images/apple.svg",
                        width: 24,
                      ),
                      heroTag: 'apple_login_button',
                    ),
                    const SizedBox(width: 24),
                    LoginButton(
                      onPressed: () => _navigateToLoginWithPaperPlane(context),
                      icon: const Icon(
                        Icons.mail_rounded,
                        size: 24,
                        color: Colors.black87,
                      ),
                      heroTag: 'email_login_button',
                    ),
                    const SizedBox(width: 24),
                    LoginButton(
                      onPressed: () =>
                          _navigateToReplacing(context, const HomeScreen()),
                      icon: const Icon(
                        Icons.phone,
                        size: 24,
                        color: Colors.black87,
                      ),
                      heroTag: 'phone_login_button',
                    )
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _navigateTo(context, const SignupScreen()),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF01A4FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
