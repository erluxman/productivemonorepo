// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/models/todo.dart';
import 'package:productive_flutter/core/providers/api_provider.dart';
import 'package:productive_flutter/core/providers/points_provider.dart';
import 'package:productive_flutter/core/services/sound_service.dart';
import 'package:productive_flutter/features/home/widgets/todo_item.dart';
import 'package:productive_flutter/features/home/widgets/todo_success_dialog.dart';
import 'package:productive_flutter/features/todo/widgets/add_todo_dialog.dart';

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
    // Only animate if the completion state changed
    if (oldWidget.isCompleted != widget.isCompleted) {
      _isAnimating = true;
      _previousCompleted = oldWidget.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not animating and completed, show full strike-through
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

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);

    return Scaffold(
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onToggle: () => _toggleTodoCompletion(context, ref, todo),
                onDelete: () => _deleteTodo(context, ref, todo),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleTodoCompletion(
      BuildContext context, WidgetRef ref, Todo todo) async {
    try {
      if (!todo.completed) {
        // Completing a todo - show dialog first, then add points
        await ref.read(todosProvider.notifier).updateTodo(
              id: todo.id,
              completed: true,
            );

        // Play sound when completing a todo
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
          if (feedMessage != null) {
            ref.read(pointsProvider.notifier).addPoints(5);

            // Update with feed message if provided
            if (feedMessage.isNotEmpty) {
              await ref.read(todosProvider.notifier).updateTodo(
                    id: todo.id,
                    description: feedMessage,
                  );
            }
          } else {
            // Dialog was dismissed, revert the todo completion
            await ref.read(todosProvider.notifier).updateTodo(
                  id: todo.id,
                  completed: false,
                );
          }
        }
      } else {
        // Unchecking a completed todo - subtract points and update
        await ref.read(todosProvider.notifier).updateTodo(
              id: todo.id,
              completed: false,
            );

        // Subtract points when unchecking a completed todo
        ref.read(pointsProvider.notifier).subtractPoints(5);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteTodo(
      BuildContext context, WidgetRef ref, Todo todo) async {
    try {
      await ref.read(todosProvider.notifier).deleteTodo(todo.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showAddTodoDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (result != null && context.mounted) {
      try {
        await ref.read(todosProvider.notifier).createTodo(
              title: result.title,
              description: result.description,
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Offset? _getPointsPosition(BuildContext context) {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    return overlay?.localToGlobal(
      Offset(MediaQuery.of(context).size.width - 60, 40),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Today at $formattedHour:$minute $period';
    } else if (dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day) {
      return 'Tomorrow at $formattedHour:$minute $period';
    } else {
      return '${dateTime.day}/${dateTime.month} at $formattedHour:$minute $period';
    }
  }
}
