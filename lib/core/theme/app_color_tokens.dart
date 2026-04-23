import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic tokens:
/// use these names in UI instead of referencing raw hex colors directly.
class AppColorTokens {
  const AppColorTokens({
    required this.background,
    required this.backgroundSecondary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textInverse,
    required this.navBarItem,
    required this.inputBackground,
    required this.tableHeader,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.borderSoft,
    required this.emptyState,
    required this.reservedState,
    required this.success,
    required this.warning,
    required this.danger,
    required this.shadow,
  });

  final Color background;
  final Color backgroundSecondary;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textInverse;
  final Color navBarItem;
  final Color inputBackground;
  final Color tableHeader;
  final Color buttonPrimary;
  final Color buttonSecondary;
  final Color borderSoft;
  final Color emptyState;
  final Color reservedState;
  final Color success;
  final Color warning;
  final Color danger;
  final Color shadow;

  static const AppColorTokens light = AppColorTokens(
    background: AppColors.cloud,
    backgroundSecondary: AppColors.porcelain,
    surfacePrimary: AppColors.snow,
    surfaceSecondary: AppColors.lavenderBlush,
    surfaceMuted: AppColors.frostBlue,
    textPrimary: AppColors.midnightNavy,
    textSecondary: AppColors.slateInk,
    textInverse: AppColors.white,
    navBarItem: AppColors.midnightNavy,
    inputBackground: AppColors.frostBlue,
    tableHeader: AppColors.powderBlue,
    buttonPrimary: AppColors.lavenderBlush,
    buttonSecondary: AppColors.powderBlue,
    borderSoft: AppColors.paleSky,
    emptyState: AppColors.mistBlue,
    reservedState: AppColors.mintFoam,
    success: AppColors.successGreen,
    warning: AppColors.warningPeach,
    danger: AppColors.dangerRose,
    shadow: Color(0x14000000),
  );

  static final AppColorTokens dark = AppColorTokens(
    background: AppColors.darkSurface,
    backgroundSecondary: AppColors.darkSurfaceSoft,
    surfacePrimary: AppColors.darkCard,
    surfaceSecondary: const Color(0xFF302845),
    surfaceMuted: const Color(0xFF26314A),
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textInverse: AppColors.midnightNavy,
    navBarItem: AppColors.darkTextPrimary,
    inputBackground: const Color(0xFF2A3350),
    tableHeader: const Color(0xFF304467),
    buttonPrimary: const Color(0xFF8D70B9),
    buttonSecondary: const Color(0xFF476187),
    borderSoft: AppColors.darkStroke,
    emptyState: const Color(0xFF23314D),
    reservedState: const Color(0xFF1F4930),
    success: const Color(0xFF66D18E),
    warning: const Color(0xFFF4BE7A),
    danger: const Color(0xFFFF8E8E),
    shadow: const Color(0x33000000),
  );
}
