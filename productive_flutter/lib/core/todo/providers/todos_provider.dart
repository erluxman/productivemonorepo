import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../models/todo.dart';
import '../services/todo_service.dart';
import '../use_cases/get_todos_use_case.dart';
import '../use_cases/create_todo_use_case.dart';
import '../use_cases/update_todo_use_case.dart';
import '../use_cases/delete_todo_use_case.dart';
import '../../errors/app_error.dart';

/// Todo service provider
final todoServiceProvider = Provider<TodoService>((ref) {
  return TodoService();
});

/// Get todos use case provider
final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return GetTodosUseCase(todoService);
});

/// Create todo use case provider
final createTodoUseCaseProvider = Provider<CreateTodoUseCase>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return CreateTodoUseCase(todoService);
});

/// Update todo use case provider
final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return UpdateTodoUseCase(todoService);
});

/// Delete todo use case provider
final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return DeleteTodoUseCase(todoService);
});

/// Todos provider - manages list of todos
final todosProvider =
    StateNotifierProvider<TodosNotifier, AsyncValue<List<Todo>>>((ref) {
  final getTodosUseCase = ref.watch(getTodosUseCaseProvider);
  final createTodoUseCase = ref.watch(createTodoUseCaseProvider);
  final updateTodoUseCase = ref.watch(updateTodoUseCaseProvider);
  final deleteTodoUseCase = ref.watch(deleteTodoUseCaseProvider);
  
  return TodosNotifier(
    getTodosUseCase: getTodosUseCase,
    createTodoUseCase: createTodoUseCase,
    updateTodoUseCase: updateTodoUseCase,
    deleteTodoUseCase: deleteTodoUseCase,
  );
});

/// Todos notifier - handles todo operations using use cases
/// Following cursor rules: Providers delegate to use cases
class TodosNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final GetTodosUseCase _getTodosUseCase;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;

  TodosNotifier({
    required GetTodosUseCase getTodosUseCase,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
  })  : _getTodosUseCase = getTodosUseCase,
        _createTodoUseCase = createTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _deleteTodoUseCase = deleteTodoUseCase,
        super(const AsyncValue.loading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = const AsyncValue.loading();
    final result = await _getTodosUseCase.execute();
    
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (todos) {
        state = AsyncValue.data(todos);
      },
    );
  }

  Future<Either<AppError, Todo>> createTodo({required Todo todo}) async {
    final result = await _createTodoUseCase.execute(todo: todo);
    
    return result.fold(
      (error) => Left(error),
      (newTodo) {
        state.whenData((todos) {
          state = AsyncValue.data([...todos, newTodo]);
        });
        return Right(newTodo);
      },
    );
  }

  Future<Either<AppError, Todo>> updateTodo({
    required String? id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    final result = await _updateTodoUseCase.execute(
      id: id,
      title: title,
      description: description,
      completed: completed,
    );
    
    return result.fold(
      (error) => Left(error),
      (updatedTodo) {
        state.whenData((todos) {
          state = AsyncValue.data(
            todos.map((todo) => todo.id != null && todo.id == id ? updatedTodo : todo).toList(),
          );
        });
        return Right(updatedTodo);
      },
    );
  }

  Future<Either<AppError, void>> deleteTodo(String? id) async {
    if (id == null) {
      return const Left(ValidationError('Todo ID is required'));
    }
    
    final result = await _deleteTodoUseCase.execute(id);
    
    return result.fold(
      (error) => Left(error),
      (_) {
        state.whenData((todos) {
          state = AsyncValue.data(
            todos.where((todo) => todo.id != null && todo.id != id).toList(),
          );
        });
        return const Right(null);
      },
    );
  }
}

