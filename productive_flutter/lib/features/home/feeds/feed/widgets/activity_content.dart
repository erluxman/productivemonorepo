import 'package:flutter/material.dart';
import 'package:productive_flutter/features/home/feeds/feed/models/feed_item.dart';

class ActivityContent extends StatelessWidget {
  final ActivityType activityType;
  final String title;
  final String subtitle;
  final int? progress;
  final String? totalDays;

  const ActivityContent({
    super.key,
    required this.activityType,
    required this.title,
    required this.subtitle,
    this.progress,
    this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        _buildActivityTypeContent(context),
      ],
    );
  }

  Widget _buildActivityTypeContent(BuildContext context) {
    if (activityType == ActivityType.todo ||
        activityType == ActivityType.habit) {
      return _buildTodoOrHabitContent();
    } else if (activityType == ActivityType.milestone) {
      return _buildMilestoneContent();
    }
    return const SizedBox.shrink();
  }

  Widget _buildTodoOrHabitContent() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activityType == ActivityType.todo
                ? Colors.blue[50]
                : Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            activityType == ActivityType.todo
                ? Icons.check_circle
                : Icons.repeat,
            color:
                activityType == ActivityType.todo ? Colors.blue : Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: index < (progress ?? 0) % 7
                      ? Colors.green
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        if (totalDays != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              totalDays!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
