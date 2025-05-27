import 'package:flutter/material.dart';
import 'package:productive_flutter/features/feed/models/feed_item.dart';
import 'package:productive_flutter/features/feed/widgets/interaction_buttons.dart';
import 'package:productive_flutter/features/feed/widgets/todo_progress.dart';
import 'package:productive_flutter/features/feed/widgets/todo_user_info.dart';

class TodoCard extends StatelessWidget {
  final FeedItem item;

  const TodoCard({
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
            TodoUserInfo(
              profileImage: item.profileImage,
              username: item.username,
              timeAgo: item.timeAgo,
              rank: item.rank,
            ),
            const SizedBox(height: 16),
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
            TodoProgress(
              progress: item.progress.toDouble(),
              priority: item.priority ?? 'Medium',
            ),
            const SizedBox(height: 16),
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
