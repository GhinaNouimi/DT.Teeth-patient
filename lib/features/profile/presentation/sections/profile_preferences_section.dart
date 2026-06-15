import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/profile_entity.dart';

class ProfilePreferencesSection extends StatelessWidget {
  final ProfileEntity profile;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLanguageTap;

  const ProfilePreferencesSection({
    super.key,
    required this.profile,
    required this.onThemeChanged,
    required this.onLanguageTap,
  });

  String get _languageLabel {
    switch (profile.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return profile.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'التفضيلات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 14),
          _CompactPreferenceRow(
            icon: Icons.dark_mode_outlined,
            title: 'الوضع الليلي',
            subtitle:
            profile.isDarkModeEnabled ? 'مفعل' : 'غير مفعل',
            trailing: Switch(
              value: profile.isDarkModeEnabled,
              onChanged: onThemeChanged,
              activeColor: colors.navBarItem,
              activeTrackColor: colors.surfaceMuted,
            ),
          ),
          Divider(
            height: 20,
            color: colors.borderSoft.withValues(alpha: 0.75),
          ),
          _CompactPreferenceRow(
            icon: Icons.language_outlined,
            title: 'اللغة',
            subtitle: _languageLabel,
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: colors.textSecondary,
            ),
            onTap: onLanguageTap,
          ),
        ],
      ),
    );
  }
}

class _CompactPreferenceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _CompactPreferenceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: colors.navBarItem,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}