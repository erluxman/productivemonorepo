// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/todo/providers/todos_provider.dart';
import 'package:productive_flutter/core/user/providers/points_provider.dart';
import 'package:productive_flutter/features/home/inbox/widgets/todo_item.dart';
import 'package:productive_flutter/features/home/inbox/widgets/todo_success_dialog.dart';
import 'package:productive_flutter/features/todo/widgets/add_todo_dialog.dart';
import 'package:productive_flutter/utils/sound_service.dart';

import '../../../models/todo.dart';

class AnimatedTodoTitle extends StatefulWidget {
  final String title;
  final bool isCompleted;

  const AnimatedTodoTitle({
    super.key,
    required this.title,
    required this.isCompleted,
  });

  @override
  State<AnimatedTodoTitle> createState() => _AnimatedTodoTitleState();
}

class _AnimatedTodoTitleState extends State<AnimatedTodoTitle> {
  late bool _isAnimating;
  late bool _previousCompleted;

  @override
  void initState() {
    super.initState();
    _isAnimating = false;
    _previousCompleted = widget.isCompleted;
  }

  @override
  void didUpdateWidget(AnimatedTodoTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted) {
      _isAnimating = true;
      _previousCompleted = oldWidget.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimating && widget.isCompleted) {
      return Text(
        widget.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _previousCompleted ? 1.0 : 0.0,
        end: widget.isCompleted ? 1.0 : 0.0,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      onEnd: () {
        setState(() {
          _isAnimating = false;
        });
      },
      builder: (context, value, child) {
        return Stack(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.isCompleted ? Colors.grey : null,
              ),
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: widget.isCompleted ? Colors.grey : null,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Inbox page refactored to use v2 architecture
/// Following cursor rules: Handle Either results properly in UI
class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(todosProvider.notifier).loadTodos(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child:
                  Text('No todos yet. Add one by tapping the + button below.'),
            );
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: todos
                  .map((todo) => TodoItem(
                        todo: todo,
                        onToggle: () =>
                            _toggleTodoCompletion(context, ref, todo),
                        onDelete: () => _deleteTodo(context, ref, todo),
                        onTap: () => _editTodo(context, ref, todo),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleTodoCompletion(
      BuildContext context, WidgetRef ref, Todo todo) async {
    if (todo.completed == false) {
      // Play sound when completing a todo
      // Completing a todo - show dialog first, then add points
      final result = await ref.read(todosProvider.notifier).updateTodo(
            id: todo.id,
            completed: true,
          );

      // Handle Either result
      result.fold(
        (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (updatedTodo) async {
          SoundService().playTodoCompleteSound();

          // Show success dialog only when completing a todo
          final targetPosition = _getPointsPosition(context);
          if (targetPosition != null) {
            final feedMessage = await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (context) => TodoSuccessDialog(
                targetPosition: targetPosition,
              ),
            );

            // Only add points if the dialog was confirmed (not dismissed)
            if (feedMessage != null && context.mounted) {
              ref.read(pointsProvider.notifier).addPoints(5);

              // Update with feed message if provided
              if (feedMessage.isNotEmpty) {
                await ref.read(todosProvider.notifier).updateTodo(
                      id: todo.id,
                      description: feedMessage,
                      completed: true,
                    );
              }
            } else if (context.mounted) {
              // Dialog was dismissed, revert the todo completion
              await ref.read(todosProvider.notifier).updateTodo(
                    id: todo.id,
                    completed: false,
                  );
            }
          }
        },
      );
    } else {
      // Unchecking a completed todo - subtract points and update
      final result = await ref.read(todosProvider.notifier).updateTodo(
            id: todo.id,
            completed: false,
          );

      result.fold(
        (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          // Subtract points when unchecking a completed todo
          ref.read(pointsProvider.notifier).subtractPoints(5);
        },
      );
    }
  }

  Future<void> _deleteTodo(
      BuildContext context, WidgetRef ref, Todo todo) async {
    if (todo.id == null) return;

    final result = await ref.read(todosProvider.notifier).deleteTodo(todo.id!);

    result.fold(
      (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (_) {
        // Success - handled by provider state update
      },
    );
  }

  Future<void> _editTodo(BuildContext context, WidgetRef ref, Todo todo) async {
    await showDialog(
      context: context,
      builder: (context) => AddTodoDialog(todoToEdit: todo),
    );
  }

  Offset? _getPointsPosition(BuildContext context) {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    return overlay?.localToGlobal(
      Offset(MediaQuery.of(context).size.width - 60, 40),
    );
  }
}
