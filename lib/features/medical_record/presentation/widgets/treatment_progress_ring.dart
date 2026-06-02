import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../utils/medical_record_accent.dart';

class TreatmentProgressRing extends StatelessWidget {
  final int percent;
  final double size;

  const TreatmentProgressRing({
    super.key,
    required this.percent,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = context.medicalAccent;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _ProgressRingPainter(
              progress: percent / 100,
              accentColor: accent,
              backgroundColor: colors.surfaceMuted,
            ),
          ),
          Text(
            '$percent%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color backgroundColor;

  const _ProgressRingPainter({
    required this.progress,
    required this.accentColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [accentColor.withValues(alpha: 0.42), accentColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
