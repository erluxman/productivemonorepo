import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
    super.key,
    required this.acceptedTerms,
    required this.privacyPolicyError,
    required this.onTermsChanged,
    required this.onPrivacyPolicyTap,
    required this.onTermsOfServiceTap,
  });

  final bool acceptedTerms;
  final bool privacyPolicyError;
  final Function(bool?) onTermsChanged;
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsOfServiceTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptedTerms,
              activeColor: colorScheme.primary,
              checkColor: colorScheme.onPrimary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: onTermsChanged,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: onPrivacyPolicyTap,
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: onTermsOfServiceTap,
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (privacyPolicyError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              'Please accept the terms to continue',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
