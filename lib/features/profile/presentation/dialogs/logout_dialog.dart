import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  final colors = context.colors;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تسجيل الخروج'),
      content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: colors.textInverse,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('خروج'),
        ),
      ],
    ),
  );

  return result ?? false;
}