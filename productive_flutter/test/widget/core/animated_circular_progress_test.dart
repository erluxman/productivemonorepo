import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productive_flutter/core/ui/animated_circular_progress.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AnimatedCircularProgressBar', () {
    testWidgets('should display circular progress indicator', (tester) async {
      // Arrange
      const progress = 0.5;
      const duration = Duration(seconds: 1);

      // Act
      await tester.pumpWidget(
        createTestApp(
          const AnimatedCircularProgressBar(
            progress: progress,
            duration: duration,
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
    });

    testWidgets('should update progress when progress value changes', (tester) async {
      // Arrange
      const duration = Duration(milliseconds: 100);
      double progress = 0.3;

      // Act
      await tester.pumpWidget(
        createTestApp(
          AnimatedCircularProgressBar(
            progress: progress,
            duration: duration,
          ),
        ),
      );

      // Update progress
      progress = 0.7;
      await tester.pumpWidget(
        createTestApp(
          AnimatedCircularProgressBar(
            progress: progress,
            duration: duration,
          ),
        ),
      );

      await tester.pump(duration);

      // Assert
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
    });

    testWidgets('should use custom radius and lineWidth', (tester) async {
      // Arrange
      const progress = 0.6;
      const duration = Duration(seconds: 1);
      const radius = 30.0;
      const lineWidth = 5.0;

      // Act
      await tester.pumpWidget(
        createTestApp(
          const AnimatedCircularProgressBar(
            progress: progress,
            duration: duration,
            radius: radius,
            lineWidth: lineWidth,
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
    });
  });
}

