// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedItem _$FeedItemFromJson(Map<String, dynamic> json) => FeedItem(
      profileImage: json['profileImage'] as String,
      username: json['username'] as String,
      timeAgo: json['timeAgo'] as String,
      rank: json['rank'] as String,
      activityType: $enumDecode(_$ActivityTypeEnumMap, json['activityType']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      timeRemaining: json['timeRemaining'] as String?,
      priority: json['priority'] as String?,
      timeSpent: json['timeSpent'] as String?,
      streak: (json['streak'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt(),
      reactions: (json['reactions'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      commenters: (json['commenters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$FeedItemToJson(FeedItem instance) => <String, dynamic>{
      'profileImage': instance.profileImage,
      'username': instance.username,
      'timeAgo': instance.timeAgo,
      'rank': instance.rank,
      'activityType': _$ActivityTypeEnumMap[instance.activityType]!,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'progress': instance.progress,
      'timeRemaining': instance.timeRemaining,
      'priority': instance.priority,
      'timeSpent': instance.timeSpent,
      'streak': instance.streak,
      'points': instance.points,
      'reactions': instance.reactions,
      'comments': instance.comments,
      'shares': instance.shares,
      'commenters': instance.commenters,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.todo: 'todo',
  ActivityType.habit: 'habit',
  ActivityType.milestone: 'milestone',
  ActivityType.feed: 'feed',
};
