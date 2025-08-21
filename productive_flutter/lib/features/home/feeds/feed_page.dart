import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/home/feeds/feed/models/feed_item.dart';
import 'package:productive_flutter/features/home/feeds/feed/providers/feed_provider.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/achievement_card.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/feed_card.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/habit_card.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/todo_card.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return feedAsync.when(
      data: (feedItems) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          final item = feedItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildCard(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading feed: $error'),
      ),
    );
  }

  Widget _buildCard(FeedItem item) {
    switch (item.activityType) {
      case ActivityType.todo:
        return TodoCard(item: item);
      case ActivityType.habit:
        return HabitCard(item: item);
      case ActivityType.milestone:
        return AchievementCard(item: item);
      default:
        return FeedCard(item: item);
    }
  }
}
