import 'package:fpdart/fpdart.dart';

import '../../errors/app_error.dart';
import '../services/todo_service.dart';

/// Use case for deleting a todo
/// Following cursor rules: Use cases return Either<AppError, T>
class DeleteTodoUseCase {
  final TodoService _todoService;

  DeleteTodoUseCase(this._todoService);

  Future<Either<AppError, void>> execute(String id) async {
    // Validation
    if (id.trim().isEmpty) {
      return const Left(ValidationError('Todo ID is required'));
    }

    // Delegate to service
    return _todoService.deleteTodo(id);
  }
}

