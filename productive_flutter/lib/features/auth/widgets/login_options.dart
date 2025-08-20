import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productive_flutter/features/home/home_screen.dart';
import 'package:productive_flutter/features/splash/widgets/login_button.dart';
import 'package:productive_flutter/core/navigation/navigation_extension.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginButton(
          onPressed: () => context.navigateToReplacing(const HomeScreen()),
          icon: SvgPicture.asset(
            "assets/images/google.svg",
            width: 24,
          ),
          heroTag: 'google_login_button_alt',
        ),
        const SizedBox(width: 24),
        LoginButton(
          onPressed: () => context.navigateToReplacing(const HomeScreen()),
          icon: SvgPicture.asset(
            "assets/images/apple.svg",
            width: 24,
          ),
          heroTag: 'apple_login_button_alt',
        ),
        const SizedBox(width: 24),
        LoginButton(
          onPressed: () => context.navigateToReplacing(const HomeScreen()),
          icon: Icon(
            Icons.phone,
            size: 24,
            color: colorScheme.onSurface,
          ),
          heroTag: 'phone_login_button_alt',
        ),
      ],
    );
  }
}
