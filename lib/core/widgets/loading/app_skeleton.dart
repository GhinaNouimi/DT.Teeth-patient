import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeleton extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const AppSkeleton({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: enabled,

      effect: ShimmerEffect(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surface,
        duration: const Duration(milliseconds: 1400),
      ),

      ignoreContainers: false,

      enableSwitchAnimation: true,

      child: child,
    );
  }
}