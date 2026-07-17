import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_extensions.dart';

class AppointmentDetailsSkeleton
    extends StatelessWidget {
  const AppointmentDetailsSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget skeletonBox({
      required double height,
      double? width,
    }) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        32,
      ),
      children: [
        skeletonBox(
          height: 24,
          width: 130,
        ),
        const SizedBox(height: 12),
        skeletonBox(height: 48),
        const SizedBox(height: 28),
        skeletonBox(
          height: 24,
          width: 100,
        ),
        const SizedBox(height: 18),
        skeletonBox(height: 58),
        const SizedBox(height: 14),
        skeletonBox(height: 58),
        const SizedBox(height: 14),
        skeletonBox(height: 58),
        const SizedBox(height: 28),
        skeletonBox(
          height: 24,
          width: 90,
        ),
        const SizedBox(height: 14),
        skeletonBox(height: 86),
        const SizedBox(height: 28),
        skeletonBox(height: 145),
      ],
    );
  }
}