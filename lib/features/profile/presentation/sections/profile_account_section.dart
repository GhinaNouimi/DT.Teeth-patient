import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../widgets/logout_action_tile.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_section_card.dart';

class ProfileAccountSection extends StatelessWidget {
  final VoidCallback onComplaintsTap;
  final VoidCallback onChangePasswordTap;
  final VoidCallback onLogoutTap;

  const ProfileAccountSection({
    super.key,
    required this.onComplaintsTap,
    required this.onChangePasswordTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ProfileSectionCard(
      title: l10n.profileAccountSupport,
      child: Column(
        children: [
          ProfileActionTile(
            title: l10n.complaintsAndSupport,
            subtitle: l10n.complaintsAndSupportSubtitle,
            icon: Icons.chat_bubble_outline_rounded,
            onTap: onComplaintsTap,
          ),
          const SizedBox(height: 8),
          ProfileActionTile(
            title: l10n.changePassword,
            subtitle: l10n.changePasswordSubtitle,
            icon: Icons.lock_outline_rounded,
            onTap: onChangePasswordTap,
          ),
          const SizedBox(height: 14),
          LogoutActionTile(onTap: onLogoutTap),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}