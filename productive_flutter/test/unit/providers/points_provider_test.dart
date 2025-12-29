import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/core/user/providers/points_provider.dart';

void main() {
  group('PointsNotifier', () {
    late PointsNotifier notifier;

    setUp(() {
      notifier = PointsNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('should initialize with 100 points', () {
      // Assert
      expect(notifier.state, 100);
    });

    test('should add points', () {
      // Act
      notifier.addPoints(50);

      // Assert
      expect(notifier.state, 150);
    });

    test('should subtract points', () {
      // Act
      notifier.subtractPoints(30);

      // Assert
      expect(notifier.state, 70);
    });

    test('should set points to specific value', () {
      // Act
      notifier.setPoints(200);

      // Assert
      expect(notifier.state, 200);
    });

    test('should reset points to 100', () {
      // Arrange
      notifier.setPoints(500);

      // Act
      notifier.resetPoints();

      // Assert
      expect(notifier.state, 100);
    });

    test('should handle multiple operations', () {
      // Act
      notifier.addPoints(50);
      notifier.subtractPoints(20);
      notifier.addPoints(10);

      // Assert
      expect(notifier.state, 140);
    });

    test('should handle negative points', () {
      // Act
      notifier.subtractPoints(150);

      // Assert
      expect(notifier.state, -50);
    });
  });
}

