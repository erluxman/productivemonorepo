import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:productive_flutter/core/todo/services/todo_service.dart';
import 'package:productive_flutter/core/auth/services/auth_service.dart';

/// Mock HTTP Client
class MockHttpClient extends Mock implements http.Client {}

/// Mock Todo Service
class MockTodoService extends Mock implements TodoService {}

/// Mock Auth Service
class MockAuthService extends Mock implements AuthService {}

/// Mock User Credential
class MockUserCredential extends Mock implements UserCredential {}

/// Mock User
class MockUser extends Mock implements User {}

/// Mock Firebase Auth Exception
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}

/// Helper to create mock HTTP response
http.Response createMockResponse({
  required int statusCode,
  required Map<String, dynamic> body,
}) {
  return http.Response(json.encode(body), statusCode);
}

/// Helper to create mock todo JSON
Map<String, dynamic> createMockTodoJson({
  String? id,
  String title = 'Test Todo',
  String? description,
  String? category,
  bool completed = false,
  bool isUrgent = false,
}) {
  return {
    'id': id ?? 'test_id',
    'title': title,
    if (description != null) 'description': description,
    if (category != null) 'category': category,
    'completed': completed,
    'isUrgent': isUrgent,
  };
}

/// Helper to create mock todos JSON list
List<Map<String, dynamic>> createMockTodosJson({int count = 3}) {
  return List.generate(
    count,
    (index) => createMockTodoJson(
      id: 'todo_$index',
      title: 'Todo $index',
      description: 'Description $index',
      completed: index % 2 == 0,
    ),
  );
}

