import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/todo.dart';
import 'services/todos_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final todosProvider =
    StateNotifierProvider<TodosNotifier, AsyncValue<List<Todo>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TodosNotifier(apiService);
});

class TodosNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final ApiService _apiService;

  TodosNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      state = const AsyncValue.loading();
      final todos = await _apiService.getTodos();
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createTodo({
    required Todo todo,
  }) async {
    try {
      final newTodo = await _apiService.createTodo(todo: todo);
      state.whenData((todos) {
        state = AsyncValue.data([...todos, newTodo]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTodo({
    required String? id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    try {
      final updatedTodo = await _apiService.updateTodo(
        id: id,
        title: title,
        description: description,
        completed: completed,
      );
      state.whenData((todos) {
        state = AsyncValue.data(
          todos.map((todo) => todo.id == id ? updatedTodo : todo).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTodo(String? id) async {
    if (id == null) return;
    try {
      await _apiService.deleteTodo(id);
      state.whenData((todos) {
        state = AsyncValue.data(
          todos.where((todo) => todo.id != id).toList(),
        );
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
