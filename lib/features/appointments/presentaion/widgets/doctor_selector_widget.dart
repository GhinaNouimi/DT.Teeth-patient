// lib/features/appointments/presentation/widgets/doctor_selector_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../doctors/presentation/models/doctor_ui_model.dart';

class DoctorSelectorWidget extends StatelessWidget {
  final List<DoctorUiModel> doctors;
  final DoctorUiModel? selectedDoctor;
  final Function(DoctorUiModel) onDoctorSelected;

  const DoctorSelectorWidget({
    super.key,
    required this.doctors,
    required this.selectedDoctor,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    if (doctors.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أطباء متاحين لهذه الخدمة',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الطبيب',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: doctors.map((doctor) {
            final isSelected = selectedDoctor?.id == doctor.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DoctorCard(
                doctor: doctor,
                isSelected: isSelected,
                onTap: () => onDoctorSelected(doctor),
                colors: colors,
                theme: theme,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorUiModel doctor;
  final bool isSelected;
  final VoidCallback onTap;
  final dynamic colors;
  final ThemeData theme;

  const _DoctorCard({
    required this.doctor,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.buttonPrimary.withValues(alpha: 0.1)
              : colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.buttonPrimary : colors.borderSoft,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.buttonPrimary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // صورة الطبيب
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.surfaceMuted,
              child: Text(
                doctor.imageUrl,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 12),
            // معلومات الطبيب
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // التقييم
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final isFilled = index < doctor.rating.toInt();
                        return Icon(
                          isFilled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: isFilled
                              ? const Color(0xFFFFC107)
                              : colors.borderSoft,
                          size: 12,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: colors.buttonPrimary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
