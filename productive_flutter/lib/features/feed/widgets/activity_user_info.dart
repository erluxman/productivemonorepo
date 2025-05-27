import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ActivityUserInfo extends StatelessWidget {
  final String profileImage;
  final String username;
  final String timeAgo;
  final String rank;

  const ActivityUserInfo({
    super.key,
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(width: 8),
                  _buildRankBadge(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileImage,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12,
            color: Colors.amber[800],
          ),
          const SizedBox(width: 4),
          Text(
            rank,
            style: TextStyle(
              color: Colors.amber[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
