import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:productive_flutter/core/todo/services/todo_service.dart';
import 'package:productive_flutter/core/errors/app_error.dart';
import 'package:productive_flutter/models/todo.dart';
import '../../helpers/mocks.dart';

void main() {
  group('TodoService', () {
    late MockHttpClient mockClient;
    late TodoService todoService;

    setUp(() {
      mockClient = MockHttpClient();
      todoService = TodoService(client: mockClient);
    });

    group('getTodos', () {
      test('should return list of todos on success', () async {
        // Arrange
        final mockTodos = createMockTodosJson(count: 3);
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(mockTodos), 200),
        );

        // Act
        final result = await todoService.getTodos();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (todos) {
            expect(todos.length, 3);
            expect(todos[0].title, 'Todo 0');
          },
        );
        verify(() => mockClient.get(any())).called(1);
      });

      test('should return NetworkError on non-200 status code', () async {
        // Arrange
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response('Error', 500),
        );

        // Act
        final result = await todoService.getTodos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (todos) => fail('Expected error but got success: $todos'),
        );
      });

      test('should return NetworkError on ClientException', () async {
        // Arrange
        when(() => mockClient.get(any())).thenThrow(
          http.ClientException('Network error'),
        );

        // Act
        final result = await todoService.getTodos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) {
            expect(error, isA<NetworkError>());
            expect(error.message, contains('Network error'));
          },
          (todos) => fail('Expected error but got success: $todos'),
        );
      });

      test('should return NetworkError on timeout', () async {
        // Arrange
        when(() => mockClient.get(any())).thenAnswer(
          (_) => Future.delayed(const Duration(seconds: 35)),
        );

        // Act
        final result = await todoService.getTodos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (todos) => fail('Expected error but got success: $todos'),
        );
      });
    });

    group('createTodo', () {
      test('should create todo successfully', () async {
        // Arrange
        final todo = Todo(title: 'New Todo', category: TodoCategory.general);
        final mockResponse = createMockTodoJson(
          id: 'new_id',
          title: 'New Todo',
        );
        when(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
            .thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 201),
        );

        // Act
        final result = await todoService.createTodo(todo: todo);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (createdTodo) {
            expect(createdTodo.title, 'New Todo');
            expect(createdTodo.id, 'new_id');
          },
        );
        verify(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
            .called(1);
      });

      test('should return NetworkError on failure', () async {
        // Arrange
        final todo = Todo(title: 'New Todo', category: TodoCategory.general);
        when(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
            .thenAnswer(
          (_) async => http.Response('Error', 400),
        );

        // Act
        final result = await todoService.createTodo(todo: todo);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (todo) => fail('Expected error but got success: $todo'),
        );
      });
    });

    group('updateTodo', () {
      test('should update todo successfully', () async {
        // Arrange
        final mockResponse = createMockTodoJson(
          id: 'test_id',
          title: 'Updated Todo',
          completed: true,
        );
        when(() => mockClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
            .thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await todoService.updateTodo(
          id: 'test_id',
          title: 'Updated Todo',
          completed: true,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (updatedTodo) {
            expect(updatedTodo.title, 'Updated Todo');
            expect(updatedTodo.completed, true);
          },
        );
      });

      test('should return ValidationError when id is null', () async {
        // Act
        final result = await todoService.updateTodo(id: null, title: 'Updated');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'Todo ID is required');
          },
          (todo) => fail('Expected error but got success: $todo'),
        );
      });

      test('should return NetworkError on failure', () async {
        // Arrange
        when(() => mockClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
            .thenAnswer(
          (_) async => http.Response('Error', 404),
        );

        // Act
        final result = await todoService.updateTodo(
          id: 'test_id',
          title: 'Updated',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (todo) => fail('Expected error but got success: $todo'),
        );
      });
    });

    group('deleteTodo', () {
      test('should delete todo successfully', () async {
        // Arrange
        when(() => mockClient.delete(any())).thenAnswer(
          (_) async => http.Response('', 200),
        );

        // Act
        final result = await todoService.deleteTodo('test_id');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected success but got error: $error'),
          (_) => expect(true, true),
        );
        verify(() => mockClient.delete(any())).called(1);
      });

      test('should return NetworkError on failure', () async {
        // Arrange
        when(() => mockClient.delete(any())).thenAnswer(
          (_) async => http.Response('Error', 404),
        );

        // Act
        final result = await todoService.deleteTodo('test_id');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (_) => fail('Expected error but got success'),
        );
      });
    });
  });
}

