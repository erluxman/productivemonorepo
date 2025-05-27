import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/providers/points_provider.dart'
    as core_points;
import 'package:productive_flutter/core/theme/app_theme.dart';
import 'package:productive_flutter/models/todo.dart';
import 'package:productive_flutter/providers/todo_provider.dart';

import 'todo_form_fields.dart';
import 'todo_success_step.dart';

enum AddTodoStep {
  edit,
  success,
}

class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({super.key});

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
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _stepAnimationController = AnimationController(
      vsync: this,
      duration: AppTheme.fabAnimationDuration,
    );
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
    final dialogHeight = _currentStep == AddTodoStep.edit ? 480.0 : 220.0;

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
          height: dialogHeight,
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
            children: [
              Text(
                _currentStep == AddTodoStep.edit ? 'Add New Todo' : 'Success',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppTheme.fabAnimationDuration,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: _buildCurrentStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case AddTodoStep.edit:
        return TodoFormFields(
          formKey: _formKey,
          selectedCategory: _selectedCategory,
          todoTitle: _todoTitle,
          deadline: _deadline,
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
          onDeadlineTap: () => _selectDeadline(context),
          onSave: _createTodo,
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
        _deadline = DateTime.now().add(const Duration(days: 1)).copyWith(
              hour: picked.hour,
              minute: picked.minute,
            );
      });
    }
  }

  void _createTodo() {
    if (!_formKey.currentState!.validate()) return;

    // Update points first
    ref.read(core_points.pointsProvider.notifier).subtractPoints(2);

    // Create and add the todo
    final newTodo = Todo(
      title: _todoTitle,
      deadline: _deadline!,
      category: _selectedCategory!,
    );

    ref.read(todoProvider.notifier).addTodo(newTodo);

    // Show success screen briefly before closing
    setState(() {
      _currentStep = AddTodoStep.success;
    });

    // Wait a moment and close the dialog
    Future.delayed(const Duration(milliseconds: 1500), () {
      _closeDialog();
    });
  }
}
