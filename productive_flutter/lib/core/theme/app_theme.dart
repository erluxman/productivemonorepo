import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 240, 239, 230),
      fontFamily: 'Product Sans',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: const Color(0xFF06D6A0),
        primary: const Color(0xFF06D6A0),
        secondary: const Color(0xFFF74F93),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        elevation: 8,
        shadowColor: Colors.black,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fabBorderRadiusSmall),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Product Sans',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF06D6A0),
        primary: const Color(0xFF06D6A0),
        secondary: const Color(0xFFF74F93),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fabBorderRadiusSmall),
        ),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        elevation: 16,
        shadowColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.black,
      ),
    );
  }

  // Common dimensions
  static const double bottomNavBarHeight = 56.0;
  static const double bottomNavBarNotchMargin = 10.0;
  static const double bottomNavBarBorderRadius = 16.0;
  static const double fabBorderRadius = 56.0;
  static const double fabBorderRadiusSmall = 16.0;
  static const double profileImageSize = 40.0;
  static const double iconSizeSmall = 24.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 28.0;

  // Animation durations
  static const Duration fabAnimationDuration = Duration(milliseconds: 200);
  static const Duration titleAnimationDuration = Duration(milliseconds: 200);
  static const Duration dialogAnimationDuration = Duration(milliseconds: 300);
  static const Duration navItemAnimationDuration = Duration(milliseconds: 300);

  // Padding values
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets navItemPadding = EdgeInsets.symmetric(vertical: 0.0);
  static const EdgeInsets profileImagePadding = EdgeInsets.all(2.0);
}
