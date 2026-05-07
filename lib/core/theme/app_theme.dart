import 'package:flutter/material.dart';

class AppTheme {
  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0F),
      primaryColor: const Color(0xFF7C5CFC),
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7C5CFC),
        secondary: Color(0xFF00E5CC),
        surface: Color(0xFF16161E),
        onSurface: Color(0xFFEAEAF4),
        onPrimary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF16161E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.white12,
    );
  }

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5FA),
      primaryColor: const Color(0xFF7C5CFC),
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7C5CFC),
        secondary: Color(0xFF00BFA5),
        surface: Colors.white,
        onSurface: Color(0xFF1A1A2E),
        onPrimary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1A1A2E),
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF444466)),
      dividerColor: Colors.black12,
    );
  }
}
