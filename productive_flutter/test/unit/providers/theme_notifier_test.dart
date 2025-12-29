import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:productive_flutter/core/theme/theme_notifier.dart';

void main() {
  group('ThemeNotifier', () {
    late ThemeNotifier notifier;

    setUp(() {
      notifier = ThemeNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('should initialize with light theme', () {
      // Assert
      expect(notifier.state, ThemeMode.light);
    });

    test('should toggle theme from light to dark', () {
      // Act
      notifier.toggleTheme();

      // Assert
      expect(notifier.state, ThemeMode.dark);
    });

    test('should toggle theme from dark to light', () {
      // Arrange
      notifier.setTheme(ThemeMode.dark);

      // Act
      notifier.toggleTheme();

      // Assert
      expect(notifier.state, ThemeMode.light);
    });

    test('should set theme to dark', () {
      // Act
      notifier.setTheme(ThemeMode.dark);

      // Assert
      expect(notifier.state, ThemeMode.dark);
    });

    test('should set theme to light', () {
      // Arrange
      notifier.setTheme(ThemeMode.dark);

      // Act
      notifier.setTheme(ThemeMode.light);

      // Assert
      expect(notifier.state, ThemeMode.light);
    });

    test('should set theme to system', () {
      // Act
      notifier.setTheme(ThemeMode.system);

      // Assert
      expect(notifier.state, ThemeMode.system);
    });
  });
}

