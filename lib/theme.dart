import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color bg = Color(0xFF0a0a0f);
  static const Color surface = Color(0xFF12121a);
  static const Color surface2 = Color(0xFF1a1a28);
  static const Color border = Color(0x12ffffff);
  static const Color accent = Color(0xFFc8ff5a);
  static const Color accent2 = Color(0xFF5af0ff);
  static const Color accent3 = Color(0xFFff5a9d);
  static const Color text = Color(0xFFf0f0f8);
  static const Color muted = Color(0xFF7070a0);

  // Fonts
  static const String fontHead = 'Syne';
  static const String fontBody = 'Space Grotesk';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent2,
        tertiary: accent3,
        surface: surface,
        onSurface: text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: text,
          letterSpacing: -1,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0x80c8ff5a)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: fontHead,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: text,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: text,
          letterSpacing: -1,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontHead,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBody,
          fontSize: 15,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBody,
          fontSize: 14,
          color: text,
        ),
        bodySmall: TextStyle(
          fontFamily: fontBody,
          fontSize: 12,
          color: muted,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: muted,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}