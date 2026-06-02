import 'package:flutter/material.dart';

class SmileDivider extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final Color? color;

  const SmileDivider({
    super.key,
    this.width = 92,
    this.height = 18,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SmileDividerPainter(
          color: lineColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _SmileDividerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _SmileDividerPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final softPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final path = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.15,
        size.width,
        size.height * 0.35,
      );

    canvas.drawPath(path, softPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SmileDividerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
