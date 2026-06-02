import 'dart:math' as math;
import 'package:flutter/material.dart';

class ToothGlowBackground extends StatefulWidget {
  final Widget child;

  const ToothGlowBackground({super.key, required this.child});

  @override
  State<ToothGlowBackground> createState() => _ToothGlowBackgroundState();
}

class _ToothGlowBackgroundState extends State<ToothGlowBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _point(double shift) {
    final angle = (_controller.value + shift) * math.pi * 2;
    return Alignment(math.cos(angle) * 0.9, math.sin(angle) * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _point(0.08),
              end: _point(0.62),
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.primary.withValues(alpha: 0.10),
                theme.colorScheme.secondary.withValues(alpha: 0.11),
                const Color(0xFF79DCCD).withValues(alpha: 0.10),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40 + (_controller.value * 24),
                left: -16,
                child: _GlowOrb(
                  size: 220,
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                ),
              ),
              Positioned(
                top: 140 - (_controller.value * 18),
                right: 12,
                child: _GlowOrb(
                  size: 130,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                bottom: -55 + (_controller.value * 26),
                right: -10,
                child: _GlowOrb(
                  size: 240,
                  color: const Color(0xFF79DCCD).withValues(alpha: 0.14),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DentalRingsPainter(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 95, spreadRadius: 18)],
      ),
    );
  }
}

class _DentalRingsPainter extends CustomPainter {
  final Color color;

  const _DentalRingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final centers = [
      Offset(size.width * 0.18, size.height * 0.22),
      Offset(size.width * 0.82, size.height * 0.75),
      Offset(size.width * 0.72, size.height * 0.18),
    ];

    for (final center in centers) {
      for (double r = 28; r <= 92; r += 18) {
        canvas.drawCircle(center, r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DentalRingsPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
