import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../models/todo.dart';
import '../../config/app_config.dart';
import '../../errors/app_error.dart';

/// Todo service for API operations
/// Following cursor rules:
/// - Network code in lib/core/ services, not in UI
/// - Handle timeouts and errors explicitly
/// - Map network errors to user-friendly messages
/// - No hardcoded URLs - use configuration
class TodoService {
  final http.Client _client;

  TodoService({http.Client? client}) : _client = client ?? http.Client();

  Future<Either<AppError, List<Todo>>> getTodos() async {
    try {
      final url = AppConfig.todosEndpoint;
      final response = await _client
          .get(Uri.parse(url))
          .timeout(AppConfig.networkTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final todos = jsonList.map((json) => Todo.fromJson(json)).toList();
        return Right(todos);
      } else {
        return Left(NetworkError(
            'Failed to load todos. Status code: ${response.statusCode}'));
      }
    } on http.ClientException catch (e) {
      return Left(NetworkError('Network error: ${e.message}'));
    } catch (e) {
      return Left(NetworkError('Failed to load todos: ${e.toString()}'));
    }
  }

  Future<Either<AppError, Todo>> createTodo({required Todo todo}) async {
    try {
      final todoBody = todo.toJson();
      final response = await _client
          .post(
            Uri.parse(AppConfig.todosEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(todoBody),
          )
          .timeout(AppConfig.networkTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(Todo.fromJson(json.decode(response.body)));
      } else {
        return Left(NetworkError(
            'Failed to create todo. Status code: ${response.statusCode}'));
      }
    } on http.ClientException catch (e) {
      return Left(NetworkError('Network error: ${e.message}'));
    } catch (e) {
      return Left(NetworkError('Failed to create todo: ${e.toString()}'));
    }
  }

  Future<Either<AppError, Todo>> updateTodo({
    required String? id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    try {
      if (id == null) {
        return const Left(ValidationError('Todo ID is required'));
      }

      final response = await _client
          .put(
            Uri.parse('${AppConfig.todosEndpoint}/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              if (title != null) 'title': title,
              if (description != null) 'description': description,
              if (completed != null) 'completed': completed,
            }),
          )
          .timeout(AppConfig.networkTimeout);

      if (response.statusCode == 200) {
        return Right(Todo.fromJson(json.decode(response.body)));
      } else {
        return Left(NetworkError(
            'Failed to update todo. Status code: ${response.statusCode}'));
      }
    } on http.ClientException catch (e) {
      return Left(NetworkError('Network error: ${e.message}'));
    } catch (e) {
      return Left(NetworkError('Failed to update todo: ${e.toString()}'));
    }
  }

  Future<Either<AppError, void>> deleteTodo(String id) async {
    try {
      final response = await _client
          .delete(Uri.parse('${AppConfig.todosEndpoint}/$id'))
          .timeout(AppConfig.networkTimeout);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(NetworkError(
            'Failed to delete todo. Status code: ${response.statusCode}'));
      }
    } on http.ClientException catch (e) {
      return Left(NetworkError('Network error: ${e.message}'));
    } catch (e) {
      return Left(NetworkError('Failed to delete todo: ${e.toString()}'));
    }
  }
}

