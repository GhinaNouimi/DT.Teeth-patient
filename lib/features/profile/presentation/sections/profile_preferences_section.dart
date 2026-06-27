import 'package:flutter/material.dart';

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

  String get _languageLabel {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'التفضيلات',
      child: Column(
        children: [
          ProfileActionTile(
            title: 'الوضع الليلي',
            subtitle: isDarkModeEnabled ? 'مفعل حاليًا' : 'غير مفعل',
            icon: Icons.dark_mode_outlined,
            onTap: () => onThemeChanged(!isDarkModeEnabled),
            trailing: Switch(
              value: isDarkModeEnabled,
              onChanged: onThemeChanged,
            ),
          ),
          const SizedBox(height: 8),
          ProfileActionTile(
            title: 'اللغة',
            subtitle: _languageLabel,
            icon: Icons.language_rounded,
            onTap: onLanguageTap,
          ),
        ],
      ),
    );
  }
}