// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class MedicalRecordHeaderSection extends StatelessWidget {
//   final String title;
//   final String subtitle;
//
//   const MedicalRecordHeaderSection({
//     super.key,
//     required this.title,
//     required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: theme.textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.w800,
//             color: colors.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           subtitle,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: colors.textSecondary,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
// }
