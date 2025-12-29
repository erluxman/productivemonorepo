import 'package:flutter/material.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';
import 'package:productive_flutter/models/todo.dart';

class TodoFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TodoCategory? selectedCategory;
  final String todoTitle;
  final String todoDescription;
  final DateTime? deadline;
  final Function(TodoCategory?) onCategoryChanged;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final VoidCallback onDeadlineTap;
  final VoidCallback onSave;
  final bool isEditing;

  const TodoFormFields({
    super.key,
    required this.formKey,
    required this.selectedCategory,
    required this.todoTitle,
    required this.todoDescription,
    required this.deadline,
    required this.onCategoryChanged,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDeadlineTap,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCategoryDropdown(context),
            const SizedBox(height: 16),
            _buildTitleInput(context),
            const SizedBox(height: 16),
            _buildDescriptionInput(context),
            const SizedBox(height: 16),
            _buildDeadlineSelector(context),
            _buildPointsInfo(context),
            const SizedBox(height: 16),
            _buildSaveButton(context),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<TodoCategory>(
        decoration: InputDecoration(
          hintText: 'Select Category',
          border: InputBorder.none,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        initialValue: selectedCategory,
        hint: Text(
          'Select Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: TodoCategory.values.map((TodoCategory category) {
          return DropdownMenuItem<TodoCategory>(
            value: category,
            child: Row(
              children: [
                Icon(category.icon, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  category.displayName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onCategoryChanged,
        validator: (value) {
          if (value == null) {
            return 'Please select a category';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTitleInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: todoTitle.isNotEmpty ? todoTitle : null,
        decoration: InputDecoration(
          hintText: 'Type Todo',
          border: InputBorder.none,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: onTitleChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a todo title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: todoDescription.isNotEmpty ? todoDescription : null,
        decoration: InputDecoration(
          hintText: 'Type Description',
          border: InputBorder.none,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: onDescriptionChanged,
        maxLines: 3,
      ),
    );
  }

  Widget _buildDeadlineSelector(BuildContext context) {
    return GestureDetector(
      onTap: onDeadlineTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.alarm,
                color: Theme.of(context).colorScheme.surface,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              deadline == null
                  ? 'Add Deadline'
                  : 'Tomorrow ${_formatTime(deadline!)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsInfo(BuildContext context) {
    if (isEditing) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 36),
        Icon(
          Icons.emoji_events,
          color: Colors.amber[600],
          size: AppTheme.iconSizeLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'A Todo costs 2 success points',
          style: TextStyle(
            color: Color(0xFFF74F93),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final bool isValid = selectedCategory != null && todoTitle.isNotEmpty;

    return ElevatedButton(
      onPressed: isValid ? onSave : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid ? const Color(0xFF06D6A0) : Colors.grey[400],
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        isEditing ? 'Update' : 'Save',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '$formattedHour:$minute $period';
  }
}
