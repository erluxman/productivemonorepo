import 'package:fpdart/fpdart.dart';

import '../../../../models/todo.dart';
import '../../errors/app_error.dart';
import '../services/todo_service.dart';

/// Use case for getting todos
/// Following cursor rules: Use cases return Either<AppError, T>
class GetTodosUseCase {
  final TodoService _todoService;

  GetTodosUseCase(this._todoService);

  Future<Either<AppError, List<Todo>>> execute() async {
    return _todoService.getTodos();
  }
}

