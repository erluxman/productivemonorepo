import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AnimatedCircularProgressBar extends StatefulWidget {
  const AnimatedCircularProgressBar({
    super.key,
    required this.progress,
    required this.duration,
    this.radius = 20,
    this.lineWidth = 3,
  });
  final double progress;
  final Duration duration;
  final double radius;
  final double lineWidth;

  @override
  State<AnimatedCircularProgressBar> createState() =>
      _AnimatedCircularProgressBarState();
}

class _AnimatedCircularProgressBarState
    extends State<AnimatedCircularProgressBar> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(AnimatedCircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _progress = widget.progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _progress, end: widget.progress),
      duration: widget.duration,
      builder: (BuildContext context, double animatedValue, Widget? child) {
        return CircularPercentIndicator(
          radius: widget.radius,
          lineWidth: widget.lineWidth,
          percent: animatedValue,
          progressColor: Colors.green,
          circularStrokeCap: CircularStrokeCap.round,
        );
      },
      onEnd: () {
        setState(() {
          _progress = widget.progress;
        });
      },
    );
  }
}

