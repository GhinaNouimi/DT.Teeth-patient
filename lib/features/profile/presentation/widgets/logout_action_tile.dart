import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'profile_action_tile.dart';

class LogoutActionTile extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutActionTile({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ProfileActionTile(
      title: l10n.logout,
      subtitle: l10n.logoutSubtitle,
      icon: Icons.logout_rounded,
      isDestructive: true,
      onTap: onTap,
    );
  }
}