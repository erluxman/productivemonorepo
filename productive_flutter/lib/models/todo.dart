import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

class Todo {
  final String id;
  final String title;
  final DateTime deadline;
  final TodoCategory category;
  final bool isCompleted;
  final bool isUrgent;
  final String? feedMessage;

  Todo({
    String? id,
    required this.title,
    required this.deadline,
    required this.category,
    this.isCompleted = false,
    this.isUrgent = false,
    this.feedMessage,
  }) : id = id ?? const Uuid().v4();

  Todo copyWith({
    String? title,
    DateTime? deadline,
    TodoCategory? category,
    bool? isCompleted,
    bool? isUrgent,
    String? feedMessage,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isUrgent: isUrgent ?? this.isUrgent,
      feedMessage: feedMessage ?? this.feedMessage,
    );
  }
}
