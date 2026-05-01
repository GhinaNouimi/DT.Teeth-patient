// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class AppointmentInfoRow extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//
//   const AppointmentInfoRow({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: colors.surfaceSecondary,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: colors.navBarItem,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: colors.textSecondary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: theme.textTheme.bodyLarge?.copyWith(
//                   color: colors.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
