import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (from the specs)
  static const Color primary = Color(0xFF003F87);          // Professional Blue
  static const Color primaryContainer = Color(0xFF0056B3); // Lighter Blue
  static const Color secondary = Color(0xFF1B6D24);        // Tech/Industrial Green
  static const Color tertiary = Color(0xFF6E2E00);         // Creative/Service Brown
  
  // Surface Hierarchy (Atelier Tonal Architecture)
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceContainerHighest = Color(0xFFE1E2E4); // Soft Fill background
  
  // Text Colors (Premium Ink Fallback)
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF44474E);
  static const Color textSecondary = Color(0xFF757575);
  
  // Status
  static const Color success = Color(0xFF1D9E75);
  static const Color error = Color(0xFFE24B4A);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    transform: GradientRotation(135 * 3.14159 / 180),
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Inter', // Default Body Font
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope', // Display font for headers
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // Fully rounded as per specs
          ),
          elevation: 0,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // xl/lg rounding
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.64, // -0.02em
          color: AppColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.48,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }
}
