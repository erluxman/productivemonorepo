import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/user/providers/points_provider.dart'
    as core_points;
import 'package:productive_flutter/core/theme/app_theme.dart';
import 'package:productive_flutter/models/todo.dart';

import '../../../core/todo/providers/todos_provider.dart';
import 'todo_form_fields.dart';
import 'todo_success_step.dart';

enum AddTodoStep {
  edit,
  success,
}

class AddTodoDialog extends ConsumerStatefulWidget {
  final Todo? todoToEdit; // Optional todo for editing

  const AddTodoDialog({super.key, this.todoToEdit});

  @override
  ConsumerState<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog>
    with SingleTickerProviderStateMixin {
  AddTodoStep _currentStep = AddTodoStep.edit;
  late AnimationController _stepAnimationController;
  final _formKey = GlobalKey<FormState>();

  // Form values
  TodoCategory? _selectedCategory;
  String _todoTitle = '';
  String _todoDescription = '';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _stepAnimationController = AnimationController(
      vsync: this,
      duration: AppTheme.fabAnimationDuration,
    );

    // Pre-fill form if editing an existing todo
    if (widget.todoToEdit != null) {
      _selectedCategory = widget.todoToEdit!.category;
      _todoTitle = widget.todoToEdit!.title;
      _todoDescription = widget.todoToEdit!.description ?? '';
      _dueDate = widget.todoToEdit!.dueDate;
    }
  }

  @override
  void dispose() {
    _stepAnimationController.dispose();
    super.dispose();
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: AppTheme.fabAnimationDuration,
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(51)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(51),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _currentStep == AddTodoStep.edit
                    ? (widget.todoToEdit != null ? 'Edit Todo' : 'Add New Todo')
                    : 'Success',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 48),
              AnimatedSwitcher(
                duration: AppTheme.fabAnimationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: _buildCurrentStep(widget.todoToEdit),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(Todo? todoToEdit) {
    switch (_currentStep) {
      case AddTodoStep.edit:
        return TodoFormFields(
          formKey: _formKey,
          selectedCategory: _selectedCategory,
          todoTitle: _todoTitle,
          todoDescription: _todoDescription,
          deadline: _dueDate,
          onCategoryChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          onTitleChanged: (value) {
            setState(() {
              _todoTitle = value;
            });
          },
          onDescriptionChanged: (value) {
            setState(() {
              _todoDescription = value;
            });
          },
          onDeadlineTap: () => _selectDeadline(context),
          onSave: _createTodo,
          isEditing: widget.todoToEdit != null,
        );
      case AddTodoStep.success:
        return const TodoSuccessStep();
    }
  }

  void _selectDeadline(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _dueDate = DateTime.now().add(const Duration(days: 1)).copyWith(
              hour: picked.hour,
              minute: picked.minute,
            );
      });
    }
  }

  void _createTodo() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.todoToEdit != null) {
      // Updating existing todo
      final result = await ref.read(todosProvider.notifier).updateTodo(
            id: widget.todoToEdit!.id,
            title: _todoTitle,
            description:
                _todoDescription.isNotEmpty ? _todoDescription : null,
          );

      if (!mounted) return;

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          // Show success screen briefly before closing
          setState(() {
            _currentStep = AddTodoStep.success;
          });

          // Wait a moment and close the dialog
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              _closeDialog();
            }
          });
        },
      );
    } else {
      // Creating new todo
      // Update points first
      ref.read(core_points.pointsProvider.notifier).subtractPoints(2);

      // Create and add the todo
      final newTodo = Todo(
        title: _todoTitle,
        dueDate: _dueDate,
        category: _selectedCategory!,
        createdAt: DateTime.now(),
        description: _todoDescription,
      );

      final result = await ref.read(todosProvider.notifier).createTodo(
            todo: newTodo,
          );

      if (!mounted) return;

      result.fold(
        (error) {
          // Revert points if todo creation failed
          ref.read(core_points.pointsProvider.notifier).addPoints(2);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          // Show success screen briefly before closing
          setState(() {
            _currentStep = AddTodoStep.success;
          });

          // Wait a moment and close the dialog
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              _closeDialog();
            }
          });
        },
      );
    }
  }
}
