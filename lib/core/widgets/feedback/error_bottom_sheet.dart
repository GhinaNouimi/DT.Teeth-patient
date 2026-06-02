import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<void> showErrorBottomSheet(
  BuildContext context, {
  required String title,
  required String message,
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
                color: theme.colorScheme.error.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: theme.colorScheme.error.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.error,
                        theme.colorScheme.error.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.error.withValues(alpha: 0.24),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                    height: 1.5,
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
