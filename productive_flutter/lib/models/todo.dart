import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

enum TodoCategory {
  habits,
  work,
  personal,
  health,
  learning;

  IconData get icon {
    switch (this) {
      case TodoCategory.habits:
        return Icons.alarm;
      case TodoCategory.work:
        return Icons.work;
      case TodoCategory.personal:
        return Icons.person;
      case TodoCategory.health:
        return Icons.favorite;
      case TodoCategory.learning:
        return Icons.book;
    }
  }

  String get displayName {
    switch (this) {
      case TodoCategory.habits:
        return 'Habits';
      case TodoCategory.work:
        return 'Work';
      case TodoCategory.personal:
        return 'Personal';
      case TodoCategory.health:
        return 'Health';
      case TodoCategory.learning:
        return 'Learning';
    }
  }
}

@JsonSerializable()
class Todo {
  final String? id;
  final String title;
  final String? description;
  final TodoCategory? category;
  final bool? completed;
  final bool? isUrgent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final String? feedMessage;

  Todo({
    String? id,
    required this.title,
    this.description,
    required this.category,
    this.completed = false,
    this.isUrgent = false,
    this.feedMessage,
    this.createdAt,
    this.updatedAt,
    this.dueDate,
  }) : id = id ?? const Uuid().v4();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    TodoCategory? category,
    bool? completed,
    bool? isUrgent,
    String? feedMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      completed: completed ?? this.completed,
      isUrgent: isUrgent ?? this.isUrgent,
      feedMessage: feedMessage ?? this.feedMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
