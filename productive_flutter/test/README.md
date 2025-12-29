# Test Suite Documentation

This directory contains comprehensive tests for the Productive Flutter application.

## Test Structure

```
test/
├── helpers/              # Test utilities and mocks
│   ├── test_helpers.dart
│   └── mocks.dart
├── unit/                 # Unit tests (90% coverage target)
│   ├── services/
│   ├── use_cases/
│   ├── providers/
│   ├── models/
│   ├── utils/
│   └── errors/
├── widget/              # Widget tests (80% coverage target)
│   ├── core/
│   ├── auth/
│   ├── todo/
│   ├── home/
│   ├── app/
│   └── golden/          # Golden/snapshot tests
└── integration/         # Integration tests (50% coverage target)
    ├── auth_flow_test.dart
    └── todo_flow_test.dart
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run Integration Tests
```bash
flutter test test/integration/
```

### Run Golden Tests
```bash
# Generate/update golden files
flutter test --update-goldens test/widget/golden/

# Run golden tests (compares against existing goldens)
flutter test test/widget/golden/
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Coverage Targets

- **Unit Tests**: 90% coverage
- **Widget Tests**: 80% coverage
- **Integration Tests**: 50% coverage

## Test Categories

### Unit Tests
- **Services**: TodoService, AuthService
- **Use Cases**: All 8 use cases (GetTodos, CreateTodo, UpdateTodo, DeleteTodo, SignIn, SignUp, SignOut, SendPasswordReset)
- **Providers**: TodosNotifier, ThemeNotifier, PointsNotifier
- **Models**: Todo model
- **Utils**: StringExtensions, SoundService, Haptics
- **Errors**: AppError types

### Widget Tests
- **Core UI**: AnimatedCircularProgressBar
- **Auth Widgets**: EmailField, PasswordField, LoginForm, SignupForm
- **Todo Widgets**: TodoItem, AddTodoDialog
- **Home Widgets**: BottomNavBar, TopBar, PointsDisplay
- **Screens**: App, SplashScreen, LoginScreen, SignupScreen, HomeScreen

### Golden Tests
- TodoItem (various states)
- Auth fields (email, password)
- Different themes (light/dark)
- Different screen sizes

### Integration Tests
- Auth flow (sign up → sign in → sign out)
- Todo flow (create → update → complete → delete)
- Navigation flow (splash → auth → home)

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('MyClass', () {
    test('should do something', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/my_widget.dart';

void main() {
  testWidgets('should display widget', (tester) async {
    await tester.pumpWidget(MyWidget());
    expect(find.text('Hello'), findsOneWidget);
  });
}
```

### Golden Test Example
```dart
import 'package:golden_toolkit/golden_toolkit.dart';

testGoldens('widget renders correctly', (tester) async {
  await tester.pumpWidgetBuilder(
    MyWidget(),
    surfaceSize: const Size(400, 100),
  );
  await screenMatchesGolden(tester, 'my_widget');
});
```

## Test Helpers

### createTestApp
Creates a test app with ProviderScope and MaterialApp wrapper.

### createTestTodo
Creates a test Todo with default or custom values.

### createTestTodos
Creates a list of test todos.

### Mocks
- `MockHttpClient`: For mocking HTTP requests
- `MockTodoService`: For mocking TodoService
- `MockAuthService`: For mocking AuthService

## Notes

- All tests use `mocktail` for mocking (no code generation required)
- Golden tests require `golden_toolkit` package
- Integration tests require Firebase emulator or mocks
- Tests follow AAA pattern (Arrange, Act, Assert)

