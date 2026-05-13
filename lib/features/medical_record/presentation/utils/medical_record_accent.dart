import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

extension MedicalRecordAccent on BuildContext {
  Color get medicalAccent => colors.buttonSecondary;
  Color get medicalAccentSoft => colors.surfaceMuted;
  Color get medicalPinkAccent => colors.buttonPrimary;
  Color get medicalPinkSoft => colors.surfaceSecondary;
  Color get medicalInk => colors.navBarItem;
}
