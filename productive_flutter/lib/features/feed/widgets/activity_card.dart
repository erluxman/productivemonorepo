import 'package:flutter/material.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';
import 'package:productive_flutter/features/feed/models/feed_item.dart';

import 'activity_content.dart';
import 'activity_user_info.dart';
import 'interaction_buttons.dart';

class ActivityCard extends StatelessWidget {
  final String profileImage;
  final String username;
  final String timeAgo;
  final String rank;
  final ActivityType activityType;
  final String title;
  final String subtitle;
  final int? progress;
  final String? totalDays;
  final int reactions;
  final int comments;
  final int shares;
  final List<String> commenters;

  const ActivityCard({
    super.key,
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.rank,
    required this.activityType,
    required this.title,
    required this.subtitle,
    this.progress,
    this.totalDays,
    required this.reactions,
    required this.comments,
    required this.shares,
    required this.commenters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.screenPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityUserInfo(
            profileImage: profileImage,
            username: username,
            timeAgo: timeAgo,
            rank: rank,
          ),
          const SizedBox(height: 16),
          ActivityContent(
            activityType: activityType,
            title: title,
            subtitle: subtitle,
            progress: progress,
            totalDays: totalDays,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InteractionButtons(
                reactions: reactions,
                comments: comments,
                shares: shares,
              ),
              const Spacer(),
              if (commenters.isNotEmpty)
                Text(
                  commenters.join(", "),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
