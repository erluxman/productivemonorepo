import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/haptics.dart';

class FlyingPoints extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback? onComplete;

  const FlyingPoints({
    super.key,
    required this.startPosition,
    required this.endPosition,
    this.onComplete,
  });

  @override
  State<FlyingPoints> createState() => _FlyingPointsState();
}

class _FlyingPointsState extends State<FlyingPoints>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _trophyScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Haptics.medium(); // Haptic feedback when points reach trophy
          widget.onComplete?.call();
        }
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _trophyScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 2.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 0.6),
        weight: 70,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _animation.value;

        // Create a more interesting curve using multiple sine waves
        final dx = Curves.easeOutQuad.transform(t);
        final horizontalPos = Offset.lerp(
          widget.startPosition,
          widget.endPosition,
          dx,
        )!;

        // Combine multiple sine waves for a more interesting vertical movement
        final primaryWave = sin(t * pi * 2) * 100;
        final secondaryWave = sin(t * pi * 4) * 30;
        final yOffset = primaryWave + secondaryWave;

        final position = Offset(horizontalPos.dx, horizontalPos.dy - yOffset);

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Row(
                children: [
                  Transform.scale(
                    scale: _trophyScaleAnimation.value,
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.amber[600],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '+5',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF74F93),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
