import 'package:fpdart/fpdart.dart';

import '../../../models/todo.dart';
import '../../errors/app_error.dart';
import '../services/todo_service.dart';

/// Use case for creating a todo
/// Following cursor rules: Use cases return Either<AppError, T>
class CreateTodoUseCase {
  final TodoService _todoService;

  CreateTodoUseCase(this._todoService);

  Future<Either<AppError, Todo>> execute({required Todo todo}) async {
    // Validation
    if (todo.title.trim().isEmpty) {
      return const Left(ValidationError('Title is required'));
    }

    // Delegate to service
    return _todoService.createTodo(todo: todo);
  }
}

