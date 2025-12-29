import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/utils/haptics.dart';

void main() {
  group('Haptics', () {
    test('should have light method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.light(), returnsNormally);
    });

    test('should have medium method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.medium(), returnsNormally);
    });

    test('should have heavy method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.heavy(), returnsNormally);
    });

    test('should have success method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.success(), returnsNormally);
    });

    test('should have selection method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.selection(), returnsNormally);
    });

    test('should have error method', () {
      // Act & Assert - Should not throw
      expect(() => Haptics.error(), returnsNormally);
    });
  });
}

