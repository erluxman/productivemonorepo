import 'package:flutter/material.dart';

class TodoProgress extends StatelessWidget {
  final double progress;
  final String priority;

  const TodoProgress({
    super.key,
    required this.progress,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress / 100.0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$progress% Complete',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priority,
                style: textTheme.labelSmall?.copyWith(
                  color: _getPriorityColor(priority),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}
