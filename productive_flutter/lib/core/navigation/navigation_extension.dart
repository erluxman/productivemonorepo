import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void pop() {
    Navigator.of(this).pop();
  }

  Future<void> navigateTo(Widget destination) async {
    await Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  Future<void> navigateToReplacing(Widget destination) async {
    await Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}

