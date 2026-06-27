import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class AppToothLogo extends StatelessWidget {
  final double size;

  const AppToothLogo({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      'assets/images/dt_teeth_logo.png',
      width: size,
      height: size,
      color: isDark ? const Color(0xFFC3AEFF) : colors.navBarItem,
      colorBlendMode: BlendMode.srcIn,
    );
  }
}