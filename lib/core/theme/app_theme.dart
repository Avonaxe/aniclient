import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2B2D42);
  static const Color accentColor = Color(0xFF00A8E1);
  static const Color backgroundColor = Color(0xFF141519); // AniList dark bg
  static const Color surfaceColor = Color(0xFF21232D); // AniList cards
  static const Color textPrimaryColor = Color(0xFFF8F9FA);
  static const Color textSecondaryColor = Color(0xFFA0B1C5);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: accentColor.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: textSecondaryColor, fontSize: 12);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: accentColor);
          }
          return const IconThemeData(color: textSecondaryColor);
        }),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textSecondaryColor),
      ),
    );
  }
}
