// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class ComplaintsHeaderSection extends StatelessWidget {
//   const ComplaintsHeaderSection({super.key});
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
//           'الشكاوى والدعم',
//           style: theme.textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.w800,
//             color: colors.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'تابع شكاويك واستفساراتك وتحديثات العيادة من مكان واحد.',
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: colors.textSecondary,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
// }