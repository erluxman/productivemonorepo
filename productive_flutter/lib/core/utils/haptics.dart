import 'package:flutter/services.dart';

class Haptics {
  // Light impact for small UI interactions
  static void light() {
    HapticFeedback.lightImpact();
  }

  // Medium impact for confirmations and completions
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  // Heavy impact for important actions or errors
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  // Success feedback for completing tasks
  static void success() {
    HapticFeedback.mediumImpact();
  }

  // Selection click for navigation and selections
  static void selection() {
    HapticFeedback.selectionClick();
  }

  // Error feedback for invalid actions
  static void error() {
    HapticFeedback.heavyImpact();
  }
}
