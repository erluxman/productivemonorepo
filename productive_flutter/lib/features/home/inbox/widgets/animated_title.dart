import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedTitle extends StatelessWidget {
  final double progress;
  final String firstTitle;
  final String secondTitle;

  const AnimatedTitle({
    super.key,
    required this.progress,
    required this.firstTitle,
    required this.secondTitle,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );

    final TextSpan firstSpan = TextSpan(
      text: firstTitle,
      style: titleStyle,
    );

    final TextSpan secondSpan = TextSpan(
      text: secondTitle,
      style: titleStyle,
    );

    final TextPainter firstPainter = TextPainter(
      text: firstSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter secondPainter = TextPainter(
      text: secondSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Use the maximum width to ensure proper sizing
    final double width = math.max(firstPainter.width, secondPainter.width) + 16;
    const double height = 40;

    return ClipRect(
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // First title
            Positioned(
              left: 0,
              top: -height * progress,
              child: Opacity(
                opacity: 1 - progress,
                child: Text(
                  firstTitle,
                  style: titleStyle,
                ),
              ),
            ),
            // Second title
            Positioned(
              left: 0,
              top: height - (height * progress),
              child: Opacity(
                opacity: progress,
                child: Text(
                  secondTitle,
                  style: titleStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
