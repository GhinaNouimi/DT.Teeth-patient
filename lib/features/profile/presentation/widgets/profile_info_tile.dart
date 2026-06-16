// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class ProfileInfoTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//
//   const ProfileInfoTile({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final theme = Theme.of(context);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: colors.surfaceSecondary,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: colors.surfacePrimary,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(
//               icon,
//               color: colors.navBarItem,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: colors.textSecondary,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: theme.textTheme.titleSmall?.copyWith(
//                     color: colors.textPrimary,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }