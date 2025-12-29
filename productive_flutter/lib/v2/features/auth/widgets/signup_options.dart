import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productive_flutter/v2/features/home/home_screen.dart';
import 'package:productive_flutter/v2/features/splash/widgets/login_button.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({
    super.key,
    required this.acceptedTerms,
    required this.navigateTo,
  });

  final bool acceptedTerms;
  final Function(BuildContext, Widget) navigateTo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Or sign up with",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginButton(
              onPressed: acceptedTerms
                  ? () => navigateTo(context, const HomeScreen())
                  : null,
              icon: SvgPicture.asset(
                "assets/images/google.svg",
                width: 24,
                colorFilter: acceptedTerms
                    ? null
                    : const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
              ),
              heroTag: 'google_signup_button',
            ),
            const SizedBox(width: 24),
            LoginButton(
              onPressed: acceptedTerms
                  ? () => navigateTo(context, const HomeScreen())
                  : null,
              icon: SvgPicture.asset(
                "assets/images/apple.svg",
                width: 24,
                colorFilter: acceptedTerms
                    ? null
                    : const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
              ),
              heroTag: 'apple_signup_button',
            ),
          ],
        ),
      ],
    );
  }
}

