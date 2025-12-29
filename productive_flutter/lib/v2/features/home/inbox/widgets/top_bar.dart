import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:productive_flutter/v2/core/theme/app_theme.dart';
import 'package:productive_flutter/v2/features/leaderboard/leaderboard_screen.dart';
import 'package:productive_flutter/v2/features/profile/profile_screen.dart';

import 'animated_points_counter.dart';
import 'animated_title.dart';

class TopBar extends StatelessWidget {
  final int points;
  final double titleProgress;

  const TopBar({
    super.key,
    required this.points,
    required this.titleProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.screenPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedTitle(
            progress: titleProgress,
            firstTitle: 'Feed',
            secondTitle: 'Inbox',
          ),
          _buildProfileSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Row(
      children: [
        _buildPointsSection(context),
        const SizedBox(width: 4),
        _buildProfileImage(context),
      ],
    );
  }

  Widget _buildPointsSection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LeaderboardScreen(),
          ),
        );
      },
      child: Container(
        padding: AppTheme.profileImagePadding,
        child: Row(
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.amber[600],
              size: AppTheme.iconSizeMedium,
            ),
            SizedBox(
              height: 32,
              child: AnimatedPointsCounter(
                value: points,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: Container(
        padding: AppTheme.profileImagePadding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Hero(
          tag: 'profile_image',
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withAlpha(26),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/user1/200',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.withAlpha(26),
                  child: const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
                memCacheHeight: 40,
                memCacheWidth: 40,
                maxHeightDiskCache: 40,
                maxWidthDiskCache: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
