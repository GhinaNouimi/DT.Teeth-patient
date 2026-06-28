// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/theme_extensions.dart';
//
// class SpecialtyFilterWidget extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const SpecialtyFilterWidget({
//     super.key,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final theme = Theme.of(context);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: selected ? colors.buttonPrimary : colors.surfaceMuted,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: selected ? colors.buttonPrimary : colors.borderSoft,
//           ),
//         ),
//         child: Text(
//           label,
//           style: theme.textTheme.labelMedium?.copyWith(
//             color: selected ? Colors.white : colors.textPrimary,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }
