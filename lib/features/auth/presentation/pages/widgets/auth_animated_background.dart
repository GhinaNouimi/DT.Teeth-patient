import 'dart:math' as math;
import 'package:flutter/material.dart';

class AuthAnimatedBackground extends StatefulWidget {
  final Widget child;

  const AuthAnimatedBackground({super.key, required this.child});

  @override
  State<AuthAnimatedBackground> createState() => _AuthAnimatedBackgroundState();
}

class _AuthAnimatedBackgroundState extends State<AuthAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _point(double seed) {
    final angle = (_controller.value + seed) * math.pi * 2;
    return Alignment(math.cos(angle), math.sin(angle));
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
              begin: _point(0.1),
              end: _point(0.55),
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.primary.withValues(alpha: 0.14),
                theme.colorScheme.secondary.withValues(alpha: 0.14),
                const Color(0xFF7CE1CC).withValues(alpha: 0.12),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50 + (_controller.value * 25),
                left: -20,
                child: _Orb(
                  size: 220,
                  color: theme.colorScheme.primary.withValues(alpha: 0.22),
                ),
              ),
              Positioned(
                top: 140 - (_controller.value * 20),
                right: 12,
                child: _Orb(
                  size: 140,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.18),
                ),
              ),
              Positioned(
                bottom: -60 + (_controller.value * 35),
                right: -10,
                child: _Orb(
                  size: 250,
                  color: const Color(0xFF63D7C1).withValues(alpha: 0.16),
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

class _Orb extends StatelessWidget {
  final double size;
  final Color color;

  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 90, spreadRadius: 18),
          ],
        ),
      ),
    );
  }
}
