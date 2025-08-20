// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: $enumDecodeNullable(_$TodoCategoryEnumMap, json['category']),
      completed: json['completed'] as bool? ?? false,
      isUrgent: json['isUrgent'] as bool? ?? false,
      feedMessage: json['feedMessage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$TodoCategoryEnumMap[instance.category],
      'completed': instance.completed,
      'isUrgent': instance.isUrgent,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'feedMessage': instance.feedMessage,
    };

const _$TodoCategoryEnumMap = {
  TodoCategory.habits: 'habits',
  TodoCategory.work: 'work',
  TodoCategory.personal: 'personal',
  TodoCategory.health: 'health',
  TodoCategory.general: 'general',
  TodoCategory.learning: 'learning',
};
