import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/points_provider.dart';
import 'animated_points_counter.dart';

class PointsDisplay extends ConsumerStatefulWidget {
  const PointsDisplay({super.key});

  @override
  ConsumerState<PointsDisplay> createState() => _PointsDisplayState();
}

class _PointsDisplayState extends ConsumerState<PointsDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyController;
  late Animation<double> _trophyScale;
  int _lastPoints = 0;

  @override
  void initState() {
    super.initState();
    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _trophyScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.8),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _trophyController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _trophyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(pointsProvider);

    // Animate trophy when points change
    if (points != _lastPoints) {
      _trophyController.forward(from: 0);
      _lastPoints = points;
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _trophyScale,
              builder: (context, child) => Transform.scale(
                scale: _trophyScale.value,
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.amber[600],
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Center(
            child: SizedBox(
              height: 32,
              child: AnimatedPointsCounter(
                value: points,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF74F93),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
