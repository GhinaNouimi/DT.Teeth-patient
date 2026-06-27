import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

Future<String?> showLanguageSelectionSheet({
  required BuildContext context,
  required String currentLanguageCode,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: context.colors.surfacePrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final theme = Theme.of(context);
      final colors = context.colors;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختيار اللغة',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            _LanguageTile(
              title: 'العربية',
              languageCode: 'ar',
              currentLanguageCode: currentLanguageCode,
            ),
            _LanguageTile(
              title: 'English',
              languageCode: 'en',
              currentLanguageCode: currentLanguageCode,
            ),
          ],
        ),
      );
    },
  );
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String languageCode;
  final String currentLanguageCode;

  const _LanguageTile({
    required this.title,
    required this.languageCode,
    required this.currentLanguageCode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = currentLanguageCode == languageCode;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onTap: () => Navigator.of(context).pop(languageCode),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colors.success)
          : null,
    );
  }
}