import 'package:flutter/material.dart';

class TodoSuccessStep extends StatelessWidget {
  const TodoSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSuccessIcon(),
          const SizedBox(height: 16),
          _buildSuccessMessage(),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
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

  Widget _buildSuccessMessage() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: const Text(
            'Todo added successfully!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        );
      },
    );
  }
}
