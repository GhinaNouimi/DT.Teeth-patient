import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/rating_bottom_sheet.dart';
import '../models/doctor_ui_model.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorUiModel doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  double userRating = 0;
  bool hasRated = false;
  String ratingMessage = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملف الطبيب'),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          /// 📸 صورة الطبيب
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  doctor.imageUrl,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// 👤 اسم الطبيب والاختصاص
          Center(
            child: Column(
              children: [
                Text(
                  doctor.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.specialty,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// 📝 النبذة
          Text(
            'عن الطبيب',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              doctor.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),

          /// 📋 سنين الخبرة
          _SectionCard(
            title: 'سنين الخبرة',
            content: '${doctor.yearsOfExperience} سنة',
            icon: Icons.work_rounded,
            colors: colors,
            theme: theme,
          ),
          const SizedBox(height: 12),

          /// 👥 المرضى المعالجين
          _SectionCard(
            title: 'المرضى المعالجين',
            content: '${doctor.treatedPatients}+ مريض',
            icon: Icons.people_rounded,
            colors: colors,
            theme: theme,
          ),
          const SizedBox(height: 20),

          /// 🎓 الشهادات والمؤهلات (بوكس واحد)
          Text(
            'الشهادات والمؤهلات',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// التخرج
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: colors.buttonPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شهادة التخرج',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.graduation,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                /// الشهادات الإضافية
                Text(
                  'شهادات إضافية',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...doctor.certificates.map((cert) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: colors.success,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            cert,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// 🔗 التواصل (رقم الطبيب فقط)
          Text(
            'التواصل',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_rounded,
                  color: colors.buttonPrimary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الهاتف',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // يمكن إضافة وظيفة الاتصال هنا
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('الرقم: ${doctor.phone}')),
                        );
                      },
                      child: Text(
                        doctor.phone,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// ⭐ التقييمات (مثل جوجل)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.borderSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// التقييم الحالي
                Text(
                  'التقييمات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${doctor.rating}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (index) {
                            final isFilled = index < doctor.rating.toInt();
                            return Icon(
                              isFilled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: isFilled
                                  ? const Color(0xFFFFC107)
                                  : colors.textPrimary,
                              size: 16,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${doctor.reviewsCount} تقييم',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // // رسم بياني بسيط للتقييمات
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     _RatingBar(
                    //       stars: 5,
                    //       count: 80,
                    //       total: doctor.reviewsCount,
                    //       colors: colors,
                    //     ),
                    //     _RatingBar(
                    //       stars: 4,
                    //       count: 60,
                    //       total: doctor.reviewsCount,
                    //       colors: colors,
                    //     ),
                    //     _RatingBar(
                    //       stars: 3,
                    //       count: 40,
                    //       total: doctor.reviewsCount,
                    //       colors: colors,
                    //     ),
                    //     _RatingBar(
                    //       stars: 2,
                    //       count: 15,
                    //       total: doctor.reviewsCount,
                    //       colors: colors,
                    //     ),
                    //     _RatingBar(
                    //       stars: 1,
                    //       count: 8,
                    //       total: doctor.reviewsCount,
                    //       colors: colors,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                /// قسم التقييم من المستخدم
                Text(
                  'قيّم الطبيب',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                /// النجوم التفاعلية
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  userRating = (index + 1).toDouble();
                                  hasRated = false;
                                  ratingMessage = '';
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(
                                    index < userRating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: index < userRating
                                        ? const Color(0xFFFFC107)
                                        : colors.textPrimary,
                                    size: 40,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (userRating > 0)
                        Text(
                          _getRatingText(userRating.toInt()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (userRating > 0)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // استدعاء ال bottom sheet التقييم
                              showRatingBottomSheet(
                                context,
                                doctorName: widget.doctor.name,
                                rating: userRating,
                                buttonText: 'حسناً',
                                onPressed: () {
                                  // إعادة تعيين التقييم
                                  setState(() {
                                    userRating = 0;
                                    hasRated = false;
                                  });
                                },
                              );
                            },
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('إرسال التقييم'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          /// زر الحجز
          ElevatedButton.icon(
            onPressed: () {
              context.push(
                AppRoutes.booking,
                extra: widget.doctor,
              );
            },
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text('احجز موعد الآن'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'ممتاز جداً! 😍';
      case 4:
        return 'جيد جداً! 😊';
      case 3:
        return 'جيد 👍';
      case 2:
        return 'حسن 👌';
      case 1:
        return 'لم يعجبني 😞';
      default:
        return '';
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final AppColorTokens colors;
  final ThemeData theme;

  const _SectionCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colors.buttonPrimary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// عنصر تقييم مع رسم بياني
// class _RatingBar extends StatelessWidget {
//   final int stars;
//   final int count;
//   final int total;
//   final AppColorTokens colors;
//
//   const _RatingBar({
//     required this.stars,
//     required this.count,
//     required this.total,
//     required this.colors,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final percentage = (count / total) * 100;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '$stars⭐',
//             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(width: 8),
//           SizedBox(
//             width: 60,
//             height: 6,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(3),
//               child: LinearProgressIndicator(
//                 value: percentage / 100,
//                 backgroundColor: colors.borderSoft,
//                 valueColor:
//                 AlwaysStoppedAnimation<Color>(colors.buttonPrimary),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '${percentage.toStringAsFixed(0)}%',
//             style: const TextStyle(fontSize: 11, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }