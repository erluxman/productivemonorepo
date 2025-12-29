# V2 Architecture Refactoring

This directory contains the refactored codebase following all Cursor rules and architectural guidelines.

## Key Changes

### 1. Error Handling with fpdart Either Pattern
- All use cases return `Either<AppError, T>` instead of throwing exceptions
- Error types: `ValidationError`, `NetworkError`, `AuthError`, `UnknownError`
- Services and use cases handle errors explicitly

### 2. Architecture Layers
```
lib/v2/
├── core/
│   ├── errors/          # Error type definitions
│   ├── config/          # Configuration (no hardcoded URLs)
│   ├── auth/
│   │   ├── services/    # Auth service (Firebase operations)
│   │   ├── use_cases/   # Auth use cases (business logic)
│   │   └── providers/   # Riverpod providers
│   ├── todo/
│   │   ├── services/    # Todo service (API operations)
│   │   ├── use_cases/   # Todo use cases (business logic)
│   │   └── providers/   # Riverpod providers
│   ├── theme/           # Theme configuration
│   ├── navigation/     # Navigation extensions
│   ├── ui/              # Shared UI components
│   └── user/            # User-related providers
├── features/            # Feature-based UI organization
├── utils/               # Utilities and extensions
└── models/              # Data models (shared with v1)
```

### 3. Separation of Concerns
- **Services**: Handle external operations (Firebase, API calls)
- **Use Cases**: Business logic and validation
- **Providers**: State management, delegate to use cases
- **UI/Features**: Presentation layer only, no business logic

### 4. Configuration
- Base URL moved to `core/config/app_config.dart`
- No hardcoded URLs in source code
- Ready for environment-based configuration

### 5. Provider Pattern
- Providers delegate to use cases
- Use cases return `Either<AppError, T>`
- UI handles Either results with `fold()` or pattern matching

## Usage Example

### In UI (Handling Either Results)

```dart
// Old way (v1)
final success = await authController.signInWithEmailAndPassword(...);
if (success) { ... }

// New way (v2)
final signInUseCase = ref.read(signInUseCaseProvider);
final result = await signInUseCase.execute(email: email, password: password);

result.fold(
  (error) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  },
  (userCredential) {
    // Handle success
    context.navigateToReplacing(const HomeScreen());
  },
);
```

### Provider Usage

```dart
// Providers automatically handle Either results
final todosAsync = ref.watch(todosProvider);

todosAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
  data: (todos) => TodoList(todos: todos),
);
```

## Migration Guide

1. **Replace direct service calls with use cases**
2. **Handle Either results in UI with `fold()` or pattern matching**
3. **Update providers to use new use case providers**
4. **Move hardcoded URLs to `AppConfig`**
5. **Ensure all errors are handled explicitly**

## Files Structure

### Core
- `core/errors/app_error.dart` - Error type definitions
- `core/config/app_config.dart` - Configuration service
- `core/auth/` - Authentication layer
- `core/todo/` - Todo layer
- `core/theme/` - Theme configuration
- `core/navigation/` - Navigation utilities
- `core/ui/` - Shared UI components
- `core/user/` - User-related providers

### Features
- `features/auth/` - Authentication screens
- `features/home/` - Home and inbox features
- `features/splash/` - Splash screen
- `features/profile/` - Profile feature
- `features/leaderboard/` - Leaderboard feature

## Testing

Following cursor rules:
- Unit tests for use cases (100% coverage target)
- Widget tests for UI components (60% coverage target)
- Integration tests for end-to-end flows

## Next Steps

1. Copy remaining feature files from `lib/features/` to `lib/v2/features/`
2. Update imports to use v2 providers and use cases
3. Refactor UI to handle Either results
4. Update `main.dart` to use v2 entry point
5. Run tests and verify behavior matches v1

