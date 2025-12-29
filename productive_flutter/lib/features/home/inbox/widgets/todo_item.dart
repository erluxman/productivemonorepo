import 'package:flutter/material.dart';

import '../../../../models/todo.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

String getIconFromCategory(TodoCategory category) {
  switch (category) {
    case TodoCategory.work:
      return "👨‍💻";
    case TodoCategory.personal:
      return "👨‍👩‍👧‍👦";
    case TodoCategory.health:
      return "💪";
    case TodoCategory.general:
      return "🏠";
    case TodoCategory.habits:
      return "🔁";
    case TodoCategory.learning:
      return "📚";
  }
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.id ?? ""),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete(),
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getIconFromCategory(widget.todo.category ?? TodoCategory.general),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: widget.onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.todo.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    if (widget.todo.description != null &&
                        widget.todo.description!.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            widget.todo.description ?? "",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(height: 8)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onToggle,
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: (widget.todo.completed ?? false)
                      ? Colors.greenAccent
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: (widget.todo.completed ?? false)
                      ? Colors.white
                      : Colors.white,
                  size: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
