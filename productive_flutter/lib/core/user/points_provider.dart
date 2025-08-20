import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointsNotifier extends StateNotifier<int> {
  PointsNotifier() : super(100); // Start with 100 points

  /// Add points (e.g., when completing a todo)
  void addPoints(int points) {
    state = state + points;
  }

  /// Subtract points (e.g., when creating a todo)
  void subtractPoints(int points) {
    state = state - points;
  }

  /// Set points to a specific value
  void setPoints(int points) {
    state = points;
  }

  /// Reset points to initial value
  void resetPoints() {
    state = 100;
  }
}

// Provider for points system
final pointsProvider = StateNotifierProvider<PointsNotifier, int>((ref) {
  return PointsNotifier();
});
