import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class ComplaintAttachmentCard extends StatelessWidget {
  final VoidCallback onTap;

  const ComplaintAttachmentCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.borderSoft,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.attach_file_rounded,
                color: colors.navBarItem,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'إضافة مرفق',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'يمكنك لاحقًا دعم الشكوى بصورة أو ملف عند جاهزية الـ API.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}