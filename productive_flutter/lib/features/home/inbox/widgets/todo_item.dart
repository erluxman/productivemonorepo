import 'package:flutter/material.dart';
import 'package:productive_flutter/utils/extensions/date_extensions.dart';

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
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 0, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getIconFromCategory(
                    widget.todo.category ?? TodoCategory.general),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    Row(
                      children: [
                        if (widget.todo.description != null &&
                            widget.todo.description!.isNotEmpty) ...[
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: Text(
                                (widget.todo.description ?? "") * 2,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8, height: 8),
                        ],
                        if (widget.todo.dueDate != null) ...[
                          Text(
                            "💣 ${widget.todo.dueDate!.toHHMM()}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ]
                      ],
                    )
                  ],
                ),
              ),
              InkWell(
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
      ),
    );
  }
}
