import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/features/home/inbox/widgets/bottom_nav_bar.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('BottomNavBar', () {
    testWidgets('should display bottom navigation bar', (tester) async {
      // Arrange
      int selectedIndex = 0;
      final notchAnimation = AlwaysStoppedAnimation<double>(0.0);
      final fabAnimationController = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      );

      // Act
      await tester.pumpWidget(
        createTestApp(
          BottomNavBar(
            selectedIndex: selectedIndex,
            notchAnimation: notchAnimation,
            fabAnimationController: fabAnimationController,
            onTabSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(BottomAppBar), findsOneWidget);
    });

    testWidgets('should call onTabSelected when item is tapped', (tester) async {
      // Arrange
      int selectedIndex = 0;
      final notchAnimation = AlwaysStoppedAnimation<double>(0.0);
      final fabAnimationController = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      );

      // Act
      await tester.pumpWidget(
        createTestApp(
          BottomNavBar(
            selectedIndex: selectedIndex,
            notchAnimation: notchAnimation,
            fabAnimationController: fabAnimationController,
            onTabSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      );

      // Find and tap second item (Inbox)
      await tester.tap(find.text('Inbox'));
      await tester.pump();

      // Assert
      expect(selectedIndex, 1);
    });
  });
}

