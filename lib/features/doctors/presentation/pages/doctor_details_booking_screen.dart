// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../core/routing/app_routes.dart';
// import '../../../../core/theme/theme_extensions.dart';
// import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
// import '../../../../core/widgets/navigation/app_top_bar.dart';
// import '../models/doctor_ui_model.dart';
// import '../widgets/availability_day_chip.dart';
// import '../widgets/availability_time_chip.dart';
// import '../widgets/doctor_meta_chip.dart';
//
// class DoctorDetailsBookingScreen extends StatefulWidget {
//   final DoctorUiModel doctor;
//
//   const DoctorDetailsBookingScreen({
//     super.key,
//     required this.doctor,
//   });
//
//   @override
//   State<DoctorDetailsBookingScreen> createState() =>
//       _DoctorDetailsBookingScreenState();
// }
//
// class _DoctorDetailsBookingScreenState
//     extends State<DoctorDetailsBookingScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//     final doctor = widget.doctor;
//
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//           children: [
//             const AppTopBar(title: 'تفاصيل الطبيب'),
//             const SizedBox(height: 18),
//
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: colors.surfacePrimary,
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: colors.borderSoft),
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 52,
//                     backgroundColor: colors.surfaceMuted,
//                     child: Icon(
//                       Icons.person_rounded,
//                       size: 54,
//                       color: colors.navBarItem,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     doctor.name,
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       color: colors.textPrimary,
//                       fontWeight: FontWeight.w800,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     doctor.specialty,
//                     style: theme.textTheme.bodyLarge?.copyWith(
//                       color: colors.textSecondary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     alignment: WrapAlignment.center,
//                     children: [
//                       DoctorMetaChip(label: '${doctor.yearsOfExperience} سنوات خبرة'),
//                       DoctorMetaChip(label: '${doctor.treatedPatients}+ مريض'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 18),
//
//             _SectionTitle(title: 'نبذة عن الطبيب'),
//             const SizedBox(height: 10),
//             Text(
//               doctor.bio,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: colors.textSecondary,
//                 height: 1.7,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(height: 18),
//
//             _SectionTitle(title: 'الشهادة'),
//             const SizedBox(height: 10),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.school_rounded,
//                   color: colors.buttonPrimary,
//                   size: 22,
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     doctor.graduation,
//                     style: theme.textTheme.bodyLarge?.copyWith(
//                       color: colors.textPrimary,
//                       fontWeight: FontWeight.w700,
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 26),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.push(
//                     AppRoutes.booking,
//                     extra: doctor,
//                   );
//                 },
//                 child: const Text('احجز موعد'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   final String title;
//
//   const _SectionTitle({
//     required this.title,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Text(
//       title,
//       style: theme.textTheme.titleMedium?.copyWith(
//         color: colors.textPrimary,
//         fontWeight: FontWeight.w800,
//       ),
//     );
//   }
// }
