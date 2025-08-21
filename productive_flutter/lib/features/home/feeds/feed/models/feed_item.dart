import 'package:json_annotation/json_annotation.dart';

part 'feed_item.g.dart';

enum ActivityType { todo, habit, milestone, feed }

@JsonSerializable()
class FeedItem {
  final String profileImage;
  final String username;
  final String timeAgo;
  final String rank;
  final ActivityType activityType;
  final String title;
  final String subtitle;
  @JsonKey(defaultValue: 0)
  final int progress;
  final String? timeRemaining;
  final String? priority; // For todo cards
  final String? timeSpent;
  final int? streak; // For habit and achievement cards
  final int? points; // For achievement cards
  @JsonKey(defaultValue: 0)
  final int reactions;
  @JsonKey(defaultValue: 0)
  final int comments;
  @JsonKey(defaultValue: 0)
  final int shares;
  @JsonKey(defaultValue: [])
  final List<String> commenters;

  FeedItem({
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.rank,
    required this.activityType,
    required this.title,
    required this.subtitle,
    this.progress = 0,
    this.timeRemaining,
    this.priority,
    this.timeSpent,
    this.streak,
    this.points,
    this.reactions = 0,
    this.comments = 0,
    this.shares = 0,
    this.commenters = const [],
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);

  get totalDays => 3;
  Map<String, dynamic> toJson() => _$FeedItemToJson(this);
}
