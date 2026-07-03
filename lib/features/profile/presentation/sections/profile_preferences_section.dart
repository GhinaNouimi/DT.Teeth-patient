import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_section_card.dart';

class ProfilePreferencesSection extends StatelessWidget {
  final bool isDarkModeEnabled;
  final String languageCode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLanguageTap;

  const ProfilePreferencesSection({
    super.key,
    required this.isDarkModeEnabled,
    required this.languageCode,
    required this.onThemeChanged,
    required this.onLanguageTap,
  });

  String _languageLabel(BuildContext context) {
    final l10n = context.l10n;

    switch (languageCode) {
      case 'ar':
        return l10n.arabic;
      case 'en':
        return l10n.english;
      default:
        return languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ProfileSectionCard(
      title: l10n.profilePreferences,
      child: Column(
        children: [
          ProfileActionTile(
            title: l10n.darkMode,
            subtitle: isDarkModeEnabled
                ? l10n.darkModeEnabled
                : l10n.darkModeDisabled,
            icon: Icons.dark_mode_outlined,
            onTap: () => onThemeChanged(!isDarkModeEnabled),
            trailing: Switch(
              value: isDarkModeEnabled,
              onChanged: onThemeChanged,
            ),
          ),
          const SizedBox(height: 8),
          ProfileActionTile(
            title: l10n.language,
            subtitle: _languageLabel(context),
            icon: Icons.language_rounded,
            onTap: onLanguageTap,
          ),
        ],
      ),
    );
  }
}