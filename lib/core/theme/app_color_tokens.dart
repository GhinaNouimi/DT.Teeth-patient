import 'package:flutter/material.dart';

import 'app_colors.dart';

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
    required this.heroStart,
    required this.heroEnd,
    required this.heroBorder,
    required this.heroButton,
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

  final Color heroStart;
  final Color heroEnd;
  final Color heroBorder;
  final Color heroButton;

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
    heroStart: AppColors.frostBlue,
    heroEnd: AppColors.lavenderBlush,
    heroBorder: AppColors.paleSky,
    heroButton: AppColors.midnightNavy,
  );

  static const AppColorTokens dark = AppColorTokens(
    background: Color(0xFF080A12),
    backgroundSecondary: Color(0xFF101522),
    surfacePrimary: Color(0xFF1A2233),
    surfaceSecondary: Color(0xFF263553),
    surfaceMuted: Color(0xFF303D5E),
    textPrimary: Color(0xFFF7F8FF),
    textSecondary: Color(0xFFC2C8DA),
    textInverse: AppColors.black,
    navBarItem: Color(0xFFA98BFF),
    inputBackground: Color(0xFF111827),
    tableHeader: Color(0xFF2C3B5C),
    buttonPrimary: Color(0xFF5D7FB8),
    buttonSecondary: Color(0xFF9B6EF3),
    borderSoft: Color(0xFF3A4668),
    emptyState: Color(0xFF151C2B),
    reservedState: Color(0xFF214B38),
    success: Color(0xFF45D483),
    warning: Color(0xFFF6B84B),
    danger: Color(0xFFFF6B75),
    shadow: Color(0x99000000),
    heroStart: Color(0xFF1E2B47),
    heroEnd: Color(0xFF111827),
    heroBorder: Color(0xFF3D4D73),
    heroButton: Color(0xFF5D7FB8),
  );
}