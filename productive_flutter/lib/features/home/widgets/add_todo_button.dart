import 'package:flutter/material.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';
import 'package:productive_flutter/features/todo/widgets/add_todo_dialog.dart';
import 'package:productive_flutter/utils/transitions/dialog_transitions.dart';

class AddTodoButton extends StatelessWidget {
  final AnimationController fabAnimationController;

  const AddTodoButton({
    super.key,
    required this.fabAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: fabAnimationController,
      child: FloatingActionButton.extended(
        heroTag: 'add_todo_fab',
        onPressed: () => _showAddTodoDialog(context),
        label: Text(
          'Add Todo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.fabBorderRadius),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _showAddTodoDialog(BuildContext context) async {
    fabAnimationController.animateTo(
      0.0,
      duration: AppTheme.dialogAnimationDuration,
      curve: Curves.easeOutCubic,
    );

    if (!context.mounted) return;

    await showCustomDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddTodoDialog(),
    );

    if (!context.mounted) return;

    fabAnimationController.animateTo(
      1.0,
      duration: AppTheme.dialogAnimationDuration,
      curve: Curves.easeInCubic,
    );
  }
}
