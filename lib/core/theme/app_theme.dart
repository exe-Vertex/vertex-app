import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF22C55E); // Green 500
  static const Color accentColor = Color(0xFF06B6D4); // Cyan 500
  static const Color darkBackground = Color(0xFF0A0F1A);
  static const Color cardBackground = Color(0xFF0F1A2A);
  static const Color surfaceColor = Color(0xFF162032);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400

  static const Color errorColor = Color(0xFFEF4444);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme:
          GoogleFonts.interTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ).copyWith(
            displayLarge: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.inter(color: textPrimary),
            bodyMedium: GoogleFonts.inter(color: textSecondary),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
