import 'package:flutter/material.dart';
import 'package:productive_flutter/v2/features/home/feeds/feed/models/feed_item.dart';
import 'package:productive_flutter/v2/features/home/feeds/feed/widgets/interaction_buttons.dart';

class HabitCard extends StatelessWidget {
  final FeedItem item;

  const HabitCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(item.profileImage),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.username,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.rank,
                      style: textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Habit info
            Text(
              item.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.progress / 100.0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            // Progress info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.progress}% Complete',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${item.timeSpent} • ${item.streak} day streak',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Interaction buttons
            InteractionButtons(
              reactions: item.reactions,
              comments: item.comments,
              shares: item.shares,
              onLike: () {},
              onComment: () {},
              onShare: () {},
            ),
          ],
        ),
      ),
    );
  }
}
