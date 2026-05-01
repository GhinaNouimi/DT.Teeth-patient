import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class DentalSmileMark extends StatelessWidget {
  const DentalSmileMark({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 90,
      height: 20,
      child: CustomPaint(
        painter: _DentalSmileMarkPainter(
          lineColor: colors.navBarItem,
          sparkleColor: colors.buttonPrimary,
        ),
      ),
    );
  }
}

class _DentalSmileMarkPainter extends CustomPainter {
  final Color lineColor;
  final Color sparkleColor;

  const _DentalSmileMarkPainter({
    required this.lineColor,
    required this.sparkleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final smilePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(4, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.05,
        size.width - 10,
        size.height * 0.35,
      );

    canvas.drawPath(smilePath, smilePaint);

    final sparkleCenter = Offset(size.width - 6, size.height * 0.22);

    final sparklePaint = Paint()
      ..color = sparkleColor
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(sparkleCenter.dx - 3, sparkleCenter.dy),
      Offset(sparkleCenter.dx + 3, sparkleCenter.dy),
      sparklePaint,
    );

    canvas.drawLine(
      Offset(sparkleCenter.dx, sparkleCenter.dy - 3),
      Offset(sparkleCenter.dx, sparkleCenter.dy + 3),
      sparklePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DentalSmileMarkPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.sparkleColor != sparkleColor;
  }
}
