# Flutter Code Layout Conventions

**Goal**: Organize Flutter code for clarity and automatic rule loading by Cursor.

**Project**: Flutter App (Productive)

---

## Project Structure

```text
lib/
  core/                    # Core services and providers
    auth/                  # Authentication services
    navigation/            # Navigation extensions
    theme/                 # Theme and styling
    todo/                  # Todo services and providers
    ui/                    # Shared UI components
    user/                  # User-related providers
  features/                # Feature-based organization
    auth/                  # Authentication screens
    home/                  # Home and inbox features
    leaderboard/           # Leaderboard feature
    profile/               # Profile feature
    splash/                # Splash screen
    todo/                  # Todo-specific widgets
  models/                  # Data models
  utils/                   # Utility functions
    extensions/            # Dart extensions
  app.dart                 # App widget
  firebase_options.dart    # Firebase configuration
  main.dart                # Entry point

test/                      # Tests
  unit_test.dart
  widget_test.dart

ai-dev/                    # AI governance + checklists + logs
.cursor/rules/             # Cursor enforcement rules (scoped)
```

---

## Current Architecture Pattern

### Core Directory

Contains shared services, providers, and infrastructure:

- **Services**: Business logic and data operations
- **Providers**: State management (Riverpod/ChangeNotifier)
- **UI Components**: Reusable widgets and transitions

### Features Directory

Feature-based organization with each feature containing:

- Screens/Pages
- Feature-specific widgets
- Local models/providers (if needed)

### Models Directory

Shared data models used across features

### Utils Directory

Helper functions, extensions, and utilities

---

## Best Practices

1. **Core vs Features**: Core contains cross-cutting concerns, Features contain domain-specific UI
2. **Providers**: Keep in core for shared state, in features for feature-specific state
3. **Widgets**: Reusable in `core/ui/`, feature-specific in `features/[feature]/widgets/`
4. **Models**: Shared models in `lib/models/`, feature-specific models in feature directory
5. **Services**: Business logic stays in `core/[concern]/services/`

---

## Rule Auto-Loading

Flutter rules auto-load for files in:

- `lib/**` → All Flutter-specific rules
- Concern-specific rules load based on file content (state, navigation, auth, etc.)

See `.cursor/rules/flutter/00_scope.mdc` for complete rule mapping.
