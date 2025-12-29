# Platform Guide: Flutter

This guide describes how Flutter work is organized and how rules apply.

## Project Root

This is a standalone Flutter application at the repository root.

## Code Layout

```text
lib/
  core/                   # Core services, providers, shared infrastructure
    auth/                 # Authentication services
    navigation/           # Navigation extensions
    theme/                # Theme and styling
    todo/                 # Todo services and providers
    ui/                   # Shared UI components
    user/                 # User-related providers
  features/               # Feature-based organization
    auth/                 # Authentication screens
    home/                 # Home and inbox features
    leaderboard/          # Leaderboard feature
    profile/              # Profile feature
    splash/               # Splash screen
    todo/                 # Todo-specific widgets
  models/                 # Data models
  utils/                  # Utility functions
    extensions/           # Dart extensions
  app.dart                # App widget
  firebase_options.dart   # Firebase configuration
  main.dart               # Entry point

test/                     # Tests
  unit_test.dart
  widget_test.dart
```

## Cursor Rule Mapping

### Always-On Rules

- `.cursor/rules/core/*.mdc` - Core constraints, workflow, security

### Flutter-Specific Rules (Auto-load for `lib/**`)

- `.cursor/rules/flutter/00_scope.mdc` - Rule scope definition
- `.cursor/rules/flutter/common_patterns.mdc` - State, UI, navigation, networking, auth, animations
- `.cursor/rules/flutter/error_handling.mdc` - Exception handling, error patterns
- `.cursor/rules/flutter/performance.mdc` - Build optimization, const constructors
- `.cursor/rules/flutter/accessibility.mdc` - Semantics, screen readers, a11y
- `.cursor/rules/flutter/testing.mdc` - Unit tests, widget tests, integration tests

## Rule Intent

- **Common Patterns**: Covers state management (BLoC/Riverpod/ChangeNotifier), UI composition, navigation, networking, auth flows, and animations
- **Error Handling**: Apply to all async operations and service calls
- **Performance**: Apply to all widgets and UI code
- **Accessibility**: Apply to all interactive UI elements
- **Testing**: Apply to test files and code requiring test coverage

## Architecture Principles

1. **Separation of Concerns**: No business logic in widgets
2. **Core vs Features**: Core contains cross-cutting concerns, Features contain domain-specific UI
3. **State Management**: Use providers/BLoC for state, keep in `core/` for shared state
4. **Services**: Business logic stays in `core/[concern]/`
5. **Reusability**: Shared UI components in `core/ui/`, feature-specific in `features/[feature]/`

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod / BLoC (ChangeNotifier)
- **Backend**: Firebase (Auth, Firestore)
- **Error Handling**: Try-catch patterns (moving to fpdart Either)
- **Testing**: flutter_test, mockito

## Key Files

- `ai-dev/DEVELOPMENT_GUIDE.md` - Quick reference for development
- `ai-dev/layout_conventions.md` - Detailed structure guide
- `ai-dev/checklists/CHECKLIST.md` - Pre-commit checklist
- `ai-dev/checklists/release/flutter.md` - Release checklist
