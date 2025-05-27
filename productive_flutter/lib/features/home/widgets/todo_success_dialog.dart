import 'package:flutter/material.dart';

import '../../../core/utils/haptics.dart';
import 'flying_points.dart';

class TodoSuccessDialog extends StatefulWidget {
  final Offset targetPosition;

  const TodoSuccessDialog({
    super.key,
    required this.targetPosition,
  });

  @override
  State<TodoSuccessDialog> createState() => _TodoSuccessDialogState();
}

class _TodoSuccessDialogState extends State<TodoSuccessDialog> {
  final _feedMessageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pointsKey = GlobalKey();
  bool _isAnimatingPoints = false;

  @override
  void dispose() {
    _feedMessageController.dispose();
    super.dispose();
  }

  Offset? _getPointsPosition() {
    final renderBox =
        _pointsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    return renderBox.localToGlobal(
      Offset(renderBox.size.width / 2, renderBox.size.height / 2),
    );
  }

  Future<String?> _startPointsAnimation() async {
    setState(() => _isAnimatingPoints = true);
    Haptics.medium(); // Haptic feedback when points start flying

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() => _isAnimatingPoints = false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(_feedMessageController.text);
    return _feedMessageController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(51)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSuccessIcon(context),
                  const SizedBox(height: 24),
                  _buildSuccessMessage(context),
                  const SizedBox(height: 8),
                  _buildPointsMessage(context),
                  const SizedBox(height: 24),
                  _buildFeedMessageField(context),
                  const SizedBox(height: 24),
                  _buildCloseButton(context),
                ],
              ),
            ),
          ),
        ),
        if (_isAnimatingPoints)
          FlyingPoints(
            startPosition: _getPointsPosition()!,
            endPosition: widget.targetPosition,
            onComplete: () {
              if (mounted) {
                setState(() {
                  _isAnimatingPoints = false;
                });
              }
            },
          ),
      ],
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: const Text(
            'Task Completed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointsMessage(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Row(
            key: _pointsKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '+5 Points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF74F93),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedMessageField(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: TextFormField(
            controller: _feedMessageController,
            maxLength: 42,
            decoration: InputDecoration(
              hintText: 'Keep a memo (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 2,
            onChanged: (value) {
              if (value.isNotEmpty) {
                Haptics.selection(); // Light feedback while typing
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: ElevatedButton(
            onPressed: _isAnimatingPoints ? null : _startPointsAnimation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(120, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              'Awesome!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
