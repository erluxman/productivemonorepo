import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productive_flutter/models/todo.dart';

class ApiService {
  static const String baseUrl =
      "https://7e342dd81424.ngrok-free.app/productive-78c0e/us-central1/api";
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Todo>> getTodos() async {
    try {
      print('Fetching todos from: $baseUrl');
      final url = '$baseUrl/todos';
      final response = await _client.get(Uri.parse(url));
      debugPrint('Response: ${response.body}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final todos = jsonList.map((json) => Todo.fromJson(json)).toList();
        print('Todos: $todos');
        return todos;
      } else {
        throw Exception(
            'Failed to load todos. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching todos: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load todos: $e');
    }
  }

  Future<Todo> createTodo({required Todo todo}) async {
    try {
      print('Creating todo with title: ${todo.title}');
      final todoBody = todo.toJson();
      final response = await _client.post(
        Uri.parse('$baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(todoBody),
      );
      print('Create todo response status: ${response.statusCode}');
      print('Create todo response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Todo.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to create todo. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error creating todo: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to create todo: $e');
    }
  }

  Future<Todo> updateTodo({
    required String? id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    try {
      print('Updating todo with id: $id');
      final response = await _client.put(
        Uri.parse('$baseUrl/todos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (completed != null) 'completed': completed,
        }),
      );
      print('Update todo response status: ${response.statusCode}');
      print('Update todo response body: ${response.body}');

      if (response.statusCode == 200) {
        return Todo.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to update todo. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error updating todo: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      print('Deleting todo with id: $id');
      final response = await _client.delete(
        Uri.parse('$baseUrl/todos/$id'),
      );
      print('Delete todo response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete todo. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error deleting todo: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to delete todo: $e');
    }
  }
}
