import 'package:fpdart/fpdart.dart';

import '../../../models/todo.dart';
import '../../errors/app_error.dart';
import '../services/todo_service.dart';

/// Use case for updating a todo
/// Following cursor rules: Use cases return Either<AppError, T>
class UpdateTodoUseCase {
  final TodoService _todoService;

  UpdateTodoUseCase(this._todoService);

  Future<Either<AppError, Todo>> execute({
    required String? id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    // Validation
    if (id == null || id.trim().isEmpty) {
      return const Left(ValidationError('Todo ID is required'));
    }

    if (title != null && title.trim().isEmpty) {
      return const Left(ValidationError('Title cannot be empty'));
    }

    // Delegate to service
    return _todoService.updateTodo(
      id: id,
      title: title?.trim(),
      description: description?.trim(),
      completed: completed,
    );
  }
}

