import 'package:flutter/material.dart';

// ── AppColors — palette résolvable selon le thème ──────────────────────────────
class AppColors {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color accent;
  final Color accent2;
  final Color accent3;
  final Color text;
  final Color muted;
  final Brightness brightness;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.accent,
    required this.accent2,
    required this.accent3,
    required this.text,
    required this.muted,
    required this.brightness,
  });

  bool get isDark => brightness == Brightness.dark;

  // ── Palette sombre (défaut) ────────────────────────────────────────
  static const dark = AppColors(
    bg:       Color(0xFF0a0a0f),
    surface:  Color(0xFF12121a),
    surface2: Color(0xFF1a1a28),
    border:   Color(0x12ffffff),
    accent:   Color(0xFFc8ff5a),
    accent2:  Color(0xFF5af0ff),
    accent3:  Color(0xFFff5a9d),
    text:     Color(0xFFf0f0f8),
    muted:    Color(0xFF7070a0),
    brightness: Brightness.dark,
  );

  // ── Palette claire ────────────────────────────────────────────────
  static const light = AppColors(
    bg:       Color(0xFFF4F4FA),
    surface:  Color(0xFFFFFFFF),
    surface2: Color(0xFFEAEAF4),
    border:   Color(0x14000000),
    accent:   Color(0xFF4E9A00),   // vert foncé (lisible sur blanc)
    accent2:  Color(0xFF0091A8),   // cyan foncé
    accent3:  Color(0xFFCC005A),   // rose foncé
    text:     Color(0xFF0A0A1A),
    muted:    Color(0xFF606090),
    brightness: Brightness.light,
  );
}

// ── AppTheme ───────────────────────────────────────────────────────────────────
class AppTheme {
  // ── Backward-compat consts (dark) — utilisés dans les const TextStyle ──
  static const Color bg       = Color(0xFF0a0a0f);
  static const Color surface  = Color(0xFF12121a);
  static const Color surface2 = Color(0xFF1a1a28);
  static const Color border   = Color(0x12ffffff);
  static const Color accent   = Color(0xFFc8ff5a);
  static const Color accent2  = Color(0xFF5af0ff);
  static const Color accent3  = Color(0xFFff5a9d);
  static const Color text     = Color(0xFFf0f0f8);
  static const Color muted    = Color(0xFF7070a0);

  static const String fontHead = 'Syne';
  static const String fontBody = 'Space Grotesk';

  // ── Résolution contextuelle ────────────────────────────────────────
  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
  }

  // ── Thème sombre ──────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const c = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.dark(
        primary: c.accent,
        secondary: c.accent2,
        tertiary: c.accent3,
        surface: c.surface,
        onSurface: c.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.accent.withAlpha(128)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: c.muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: fontHead,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          side: BorderSide(color: c.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontHead,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c.text,
        ),
        titleLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: c.text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: c.text,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBody,
          fontSize: 15,
          color: c.text,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBody,
          fontSize: 14,
          color: c.text,
        ),
        bodySmall: TextStyle(
          fontFamily: fontBody,
          fontSize: 12,
          color: c.muted,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: c.muted,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: c.accent,
        unselectedItemColor: c.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // ── Thème clair ───────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const c = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.light(
        primary: c.accent,
        secondary: c.accent2,
        tertiary: c.accent3,
        surface: c.surface,
        onSurface: c.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
        iconTheme: IconThemeData(color: c.muted),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.accent.withAlpha(160)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: c.muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: fontHead,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          side: BorderSide(color: c.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontHead,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: c.text,
          letterSpacing: -1,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontHead,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c.text,
        ),
        titleLarge: TextStyle(
          fontFamily: fontHead,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: c.text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: c.text,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBody,
          fontSize: 15,
          color: c.text,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBody,
          fontSize: 14,
          color: c.text,
        ),
        bodySmall: TextStyle(
          fontFamily: fontBody,
          fontSize: 12,
          color: c.muted,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: c.muted,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: c.accent,
        unselectedItemColor: c.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: c.border,
    );
  }
}

// ── Extension BuildContext pour un accès court ────────────────────────────────
extension AppThemeX on BuildContext {
  AppColors get dv => AppTheme.of(this);
}
