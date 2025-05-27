import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/feed/providers/feed_provider.dart';
import 'package:productive_flutter/features/feed/widgets/activity_card.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return feedAsync.when(
      data: (feedItems) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          final item = feedItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ActivityCard(
              profileImage: item.profileImage,
              username: item.username,
              timeAgo: item.timeAgo,
              rank: item.rank,
              activityType: item.activityType,
              title: item.title,
              subtitle: item.subtitle,
              progress: item.progress,
              totalDays: item.totalDays,
              reactions: item.reactions,
              comments: item.comments,
              shares: item.shares,
              commenters: item.commenters,
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading feed: $error'),
      ),
    );
  }
}
