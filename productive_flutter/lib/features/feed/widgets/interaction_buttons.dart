import 'package:flutter/material.dart';

class InteractionButtons extends StatelessWidget {
  final int reactions;
  final int comments;
  final int shares;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const InteractionButtons({
    super.key,
    required this.reactions,
    required this.comments,
    required this.shares,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInteractionButton(
          icon: Icons.favorite_border,
          label: reactions.toString(),
          onTap: onLike,
        ),
        _buildInteractionButton(
          icon: Icons.comment_outlined,
          label: comments.toString(),
          onTap: onComment,
        ),
        _buildInteractionButton(
          icon: Icons.share_outlined,
          label: shares.toString(),
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
