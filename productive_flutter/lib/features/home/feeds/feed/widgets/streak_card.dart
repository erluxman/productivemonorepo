import 'package:flutter/material.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/streak_content.dart';
import 'package:productive_flutter/features/home/feeds/feed/widgets/streak_user_info.dart';

class StreakCard extends StatelessWidget {
  final String username;
  final String habit;
  final int streak;
  final String totalTime;
  final String avatarUrl;

  const StreakCard({
    super.key,
    required this.username,
    required this.habit,
    required this.streak,
    required this.totalTime,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreakUserInfo(
              username: username,
              avatarUrl: avatarUrl,
              streak: streak,
            ),
            const SizedBox(height: 16),
            StreakContent(
              habit: habit,
              totalTime: totalTime,
            ),
          ],
        ),
      ),
    );
  }
}
