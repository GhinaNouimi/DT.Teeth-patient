import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/widgets/branding/smile_divider.dart';
import '../../../../../core/widgets/branding/tooth_glow_background.dart';



class AuthShell extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String? bottomText;
  final String? bottomActionText;
  final VoidCallback? onBottomTap;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottomText,
    this.bottomActionText,
    this.onBottomTap,
  });

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ToothGlowBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: AnimatedBuilder(
                  animation: _borderController,
                  builder: (context, _) {
                    return Container(
                      padding: const EdgeInsets.all(1.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: SweepGradient(
                          transform: GradientRotation(
                            _borderController.value * 6.28,
                          ),
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.95),
                            theme.colorScheme.secondary.withValues(alpha: 0.75),
                            const Color(0xFF63D7C1).withValues(alpha: 0.75),
                            theme.colorScheme.primary.withValues(alpha: 0.95),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            blurRadius: 26,
                            spreadRadius: 1,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(33),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(33),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const SmileDivider(),
                                const SizedBox(height: 12),
                                Text(
                                  widget.subtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.75),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                widget.child,
                                if (widget.bottomText != null &&
                                    widget.bottomActionText != null) ...[
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.bottomText!,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.75),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: widget.onBottomTap,
                                        child: Text(widget.bottomActionText!),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                      duration: 320.ms,
                    ).slideY(
                      begin: 0.03,
                      end: 0,
                      duration: 320.ms,
                      curve: Curves.easeOutCubic,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
