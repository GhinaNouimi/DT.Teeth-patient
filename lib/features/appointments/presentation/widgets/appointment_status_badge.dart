// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class AppointmentStatusBadge extends StatelessWidget {
//   final String label;
//
//   const AppointmentStatusBadge({
//     super.key,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: colors.surfaceMuted,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Text(
//         label,
//         style: theme.textTheme.bodyMedium?.copyWith(
//           color: colors.navBarItem,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }
