import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/app.dart';

void main() async {
  // Enable Flutter scrolling on desktop platforms
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set scroll behavior for desktop platforms
  GestureBinding.instance.resamplingEnabled = true;

  runApp(
    const ProviderScope(
      child: ProductiveApp(),
    ),
  );
}
