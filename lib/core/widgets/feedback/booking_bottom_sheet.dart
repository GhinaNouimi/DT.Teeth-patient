import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<void> showBookingBottomSheet(
  BuildContext context, {
  required String doctorName,
  required String date,
  required String time,
  required String buttonText,
  VoidCallback? onPressed,
}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.black.withValues(alpha: 0.18),
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// أيقونة الحجز
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onSurface,

                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.24,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 18),
                Text(
                  'تم حجز الموعد بنجاح!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                /// تفاصيل الحجز
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    children: [
                      _BookingDetailRow(
                        icon: Icons.person_rounded,
                        label: 'الطبيب',
                        value: doctorName,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _BookingDetailRow(
                        icon: Icons.calendar_today_rounded,
                        label: 'التاريخ',
                        value: date,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _BookingDetailRow(
                        icon: Icons.schedule_rounded,
                        label: 'الوقت',
                        value: time,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'سيتم إرسال تفاصيل الموعد إليك عند التأكيد',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      onPressed?.call();
                    },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.18, end: 0);
    },
  );
}

class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
