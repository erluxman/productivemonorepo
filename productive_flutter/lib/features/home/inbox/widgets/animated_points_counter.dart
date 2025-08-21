import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedPointsCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;

  const AnimatedPointsCounter({
    super.key,
    required this.value,
    this.style,
  });

  @override
  State<AnimatedPointsCounter> createState() => _AnimatedPointsCounterState();
}

class _AnimatedPointsCounterState extends State<AnimatedPointsCounter>
    with SingleTickerProviderStateMixin {
  late int _oldValue;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(AnimatedPointsCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final isIncreasing = widget.value > _oldValue;
        final formattedOldNumber = _formatNumber(_oldValue);
        final formattedNewNumber = _formatNumber(widget.value);
        final maxWidth = max(
          formattedOldNumber.length * 14,
          formattedNewNumber.length * 14,
        );

        return SizedBox(
          width: maxWidth.toDouble(),
          child: ClipRect(
            child: Stack(
              children: [
                // Current number (slides out)
                Transform.translate(
                  offset:
                      Offset(0, isIncreasing ? -32 * progress : 32 * progress),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedOldNumber,
                      style: widget.style,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                // New number (slides in)
                Transform.translate(
                  offset: Offset(
                    0,
                    isIncreasing
                        ? 32 * (1 - progress) // Comes from bottom
                        : -32 * (1 - progress), // Comes from top
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedNewNumber,
                      style: widget.style,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
