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
    required this.successBackground,
    required this.successForeground,
    required this.successBorder,
    required this.warningBackground,
    required this.warningForeground,
    required this.warningBorder,
    required this.dangerBackground,
    required this.dangerForeground,
    required this.dangerBorder,
    required this.infoBackground,
    required this.infoForeground,
    required this.infoBorder,
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

  final Color successBackground;
  final Color successForeground;
  final Color successBorder;

  final Color warningBackground;
  final Color warningForeground;
  final Color warningBorder;

  final Color dangerBackground;
  final Color dangerForeground;
  final Color dangerBorder;

  final Color infoBackground;
  final Color infoForeground;
  final Color infoBorder;

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
    warning: AppColors.warningText,
    danger: AppColors.dangerRose,

    successBackground: AppColors.successBackground,
    successForeground: AppColors.successText,
    successBorder: AppColors.successBorder,

    warningBackground: AppColors.warningBackground,
    warningForeground: AppColors.warningText,
    warningBorder: AppColors.warningBorder,

    dangerBackground: AppColors.dangerBackground,
    dangerForeground: AppColors.dangerText,
    dangerBorder: AppColors.dangerBorder,

    infoBackground: AppColors.infoBackground,
    infoForeground: AppColors.infoText,
    infoBorder: AppColors.infoBorder,

    shadow: Color(0x14000000),

    heroStart: AppColors.frostBlue,
    heroEnd: AppColors.lavenderBlush,
    heroBorder: AppColors.paleSky,
    heroButton: AppColors.midnightNavy,
  );

  static const AppColorTokens dark = AppColorTokens(
    background: AppColors.darkSurface,
    backgroundSecondary: AppColors.darkSurfaceSoft,
    surfacePrimary: AppColors.darkCard,
    surfaceSecondary: AppColors.darkElevatedCard,
    surfaceMuted: AppColors.darkTableHeader,

    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textInverse: AppColors.black,

    navBarItem: AppColors.darkPrimaryPurple,

    inputBackground: AppColors.darkInput,
    tableHeader: AppColors.darkTableHeader,

    buttonPrimary: AppColors.darkSecondaryBlue,
    buttonSecondary: AppColors.darkPrimaryPurple,

    borderSoft: AppColors.darkStroke,
    emptyState: AppColors.darkSurfaceSoft,
    reservedState: AppColors.darkSuccessBackground,

    success: AppColors.darkSuccess,
    warning: AppColors.darkWarning,
    danger: AppColors.darkDanger,

    successBackground: AppColors.darkSuccessBackground,
    successForeground: AppColors.darkSuccessText,
    successBorder: AppColors.darkSuccessBorder,

    warningBackground: AppColors.darkWarningBackground,
    warningForeground: AppColors.darkWarningText,
    warningBorder: AppColors.darkWarningBorder,

    dangerBackground: AppColors.darkDangerBackground,
    dangerForeground: AppColors.darkDangerText,
    dangerBorder: AppColors.darkDangerBorder,

    infoBackground: AppColors.darkInfoBackground,
    infoForeground: AppColors.darkInfoText,
    infoBorder: AppColors.darkInfoBorder,

    shadow: Color(0x99000000),

    heroStart: AppColors.darkElevatedCard,
    heroEnd: AppColors.darkSurfaceSoft,
    heroBorder: AppColors.darkStroke,
    heroButton: AppColors.darkSecondaryBlue,
  );
}