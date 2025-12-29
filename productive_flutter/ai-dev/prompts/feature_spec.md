# Prompt: Feature Spec

@ai-dev/DEVELOPMENT_GUIDE.md @ai-dev/layout_conventions.md

Write a 10-line spec using this format:

```text
**Feature**: Todo
**Purpose**: Create, delete, edit, check on/off the todo
**Behavior**: responsive app
**Constraints**: follow all the architectural criteria and limitation as defined in cursor rules, .cursor.rules
**Acceptance Criteria**: Create, delete, edit, check on/off the todo and follows material design

Shall have unit and ui tests

Shall have integration test in browser
```

## Rules

- Ask clarifying questions if anything is ambiguous.
- Do not propose implementation yet. STOP. Wait for approval.

---

## Example

**Feature**: Todo Management Application  
**Purpose**: Allow users to manage their todos by creating, editing, deleting, and toggling completion status  
**Behavior**: Flutter mobile application that displays a list of todos with ability to add new todos, edit existing ones, delete todos, and toggle completion status; todos persist in Firestore  
**Constraints**: No business logic in widgets, services in lib/core/, state management via BLoC/Riverpod/ChangeNotifier, follow Flutter conventions from .cursor/rules, no hardcoded values, all errors must be handled  
**Acceptance Criteria**: User can create/edit/delete/toggle todos, UI follows Material Design, responsive, todos persist in Firestore, proper error handling, unit/widget/integration tests
