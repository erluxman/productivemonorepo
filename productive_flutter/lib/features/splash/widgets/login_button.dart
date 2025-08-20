import 'package:flutter/material.dart';

import '../../../utils/haptics.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed != null
          ? () {
              Haptics.selection();
              onPressed!();
            }
          : null,
      elevation: onPressed != null ? 4 : 0,
      backgroundColor: onPressed != null ? Colors.white : Colors.grey[200],
      heroTag: heroTag,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
