import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/utils/sound_service.dart';

void main() {
  group('SoundService', () {
    test('should be a singleton', () {
      // Act
      final instance1 = SoundService();
      final instance2 = SoundService();

      // Assert
      expect(instance1, same(instance2));
    });

    test('should have playTodoCompleteSound method', () {
      // Arrange
      final service = SoundService();

      // Act & Assert - Should not throw
      expect(() => service.playTodoCompleteSound(), returnsNormally);
    });

    test('should have playSuccessSound method', () {
      // Arrange
      final service = SoundService();

      // Act & Assert - Should not throw
      expect(() => service.playSuccessSound(), returnsNormally);
    });

    test('should have dispose method', () {
      // Arrange
      final service = SoundService();

      // Act & Assert - Should not throw
      expect(() => service.dispose(), returnsNormally);
    });
  });
}

