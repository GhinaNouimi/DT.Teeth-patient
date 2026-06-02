import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_tokens.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme =>
      _buildTheme(AppColorTokens.light, Brightness.light);

  static ThemeData get darkTheme =>
      _buildTheme(AppColorTokens.dark, Brightness.dark);

  static ThemeData _buildTheme(AppColorTokens colors, Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.buttonPrimary,
          brightness: brightness,
        ).copyWith(
          primary: colors.buttonPrimary,
          onPrimary: colors.textPrimary,
          secondary: colors.buttonSecondary,
          onSecondary: colors.textPrimary,
          error: colors.danger,
          onError: colors.textInverse,
          surface: colors.surfacePrimary,
          onSurface: colors.textPrimary,
          tertiary: colors.reservedState,
          onTertiary: colors.textPrimary,
          outline: colors.borderSoft,
          shadow: colors.shadow,
          scrim: colors.shadow,
          inverseSurface: colors.textPrimary,
          onInverseSurface: colors.textInverse,
          inversePrimary: colors.navBarItem,
        );

    final baseTextTheme = GoogleFonts.alexandriaTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfacePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.borderSoft),
        ),
      ),
      dividerColor: colors.borderSoft,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBackground,
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
        ),
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: colors.textSecondary,
        suffixIconColor: colors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.navBarItem, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.danger, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.borderSoft),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surfacePrimary,
        selectedItemColor: colors.navBarItem,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonPrimary,
          foregroundColor: colors.textPrimary,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.navBarItem,
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceSecondary,
        disabledColor: colors.surfaceMuted,
        selectedColor: colors.buttonSecondary,
        secondarySelectedColor: colors.buttonPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: colors.textPrimary,
        ),
        secondaryLabelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: colors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.borderSoft),
        ),
        brightness: brightness,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
          height: 1.2,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.25,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          height: 1.45,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}
