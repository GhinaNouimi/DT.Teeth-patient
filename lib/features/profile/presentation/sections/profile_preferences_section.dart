import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_action_tile.dart';

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
    return ProfileSectionCard(
      title: 'التفضيلات',
      child: Column(
        children: [
          ProfileActionTile(
            title: 'الوضع الليلي',
            subtitle: profile.isDarkModeEnabled ? 'مفعل حاليًا' : 'غير مفعل',
            icon: Icons.dark_mode_outlined,
            onTap: () => onThemeChanged(!profile.isDarkModeEnabled),
            trailing: Switch(
              value: profile.isDarkModeEnabled,
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