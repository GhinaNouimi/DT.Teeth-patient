import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();

    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 3600));
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(_controller.value);

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.2 + (t * 0.35), -0.6 + (t * 0.2)),
                radius: 1.3,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.18),
                  theme.colorScheme.secondary.withValues(alpha: 0.12),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  left: -20,
                  child: _GlowSphere(
                    size: 230,
                    color: theme.colorScheme.primary.withValues(alpha: 0.22),
                  ),
                ),
                Positioned(
                  top: 160,
                  right: -20,
                  child: _GlowSphere(
                    size: 180,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.18),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: 10,
                  child: _GlowSphere(
                    size: 260,
                    color: const Color(0xFF63D7C1).withValues(alpha: 0.14),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 0.82 + (t * 0.18),
                          child: Transform.translate(
                            offset: Offset(0, 16 - (t * 16)),
                            child: Container(
                              width: 210,
                              height: 210,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.78),
                                    theme.colorScheme.primary.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(48),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.32),
                                        borderRadius: BorderRadius.circular(38),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.35),
                                        ),
                                      ),
                                      child: Image.asset(
                                        AppAssets.logo,
                                        fit: BoxFit.contain,
                                      )
                                          .animate()
                                          .fadeIn(duration: 450.ms)
                                          .scale(
                                        duration: 900.ms,
                                        curve: Curves.easeOutBack,
                                      )
                                          .shimmer(
                                        duration: 1300.ms,
                                        delay: 500.ms,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'DT.Teeth',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 500.ms)
                            .slideY(begin: 0.25, end: 0),
                        const SizedBox(height: 10),
                        Text(
                          'رعاية أسنان حديثة تبدأ بتجربة رقمية أنيقة',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 820.ms, duration: 500.ms)
                            .slideY(begin: 0.18, end: 0),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.10),
                            ),
                          ),
                        ).animate().fadeIn(delay: 1100.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GlowSphere extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowSphere({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
