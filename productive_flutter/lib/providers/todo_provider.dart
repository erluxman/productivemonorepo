import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier()
      : super([
          // Add some sample todos
          Todo(
            title: "Wake up before 5:00 AM",
            dueDate: DateTime.now()
                .add(const Duration(days: 1))
                .copyWith(hour: 5, minute: 0),
            category: TodoCategory.habits,
            isUrgent: true,
          ),
          Todo(
            title: "Write tomorrow's TODO",
            dueDate: DateTime.now().copyWith(hour: 20, minute: 30),
            category: TodoCategory.personal,
            completed: true,
          ),
          Todo(
            title: "Read Atomic Habits",
            dueDate: DateTime.now().copyWith(hour: 21, minute: 15),
            category: TodoCategory.learning,
          ),
        ]);

  // Add a new todo
  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  // Toggle the completion status of a todo
  void toggleTodoCompletion(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !(todo.completed ?? false));
      }
      return todo;
    }).toList();
  }

  // Delete a todo
  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  // Update a todo's feed message
  void updateTodoFeedMessage(String id, String feedMessage) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(feedMessage: feedMessage);
      }
      return todo;
    }).toList();
  }

  // Update a todo
  void updateTodo(Todo updatedTodo) {
    state = state.map((todo) {
      if (todo.id == updatedTodo.id) {
        return updatedTodo;
      }
      return todo;
    }).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

// Provider for points system
final pointsProvider = StateProvider<int>((ref) => 100);
