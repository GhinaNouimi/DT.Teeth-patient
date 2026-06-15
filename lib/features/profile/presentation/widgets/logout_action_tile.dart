import 'package:flutter/material.dart';

import 'profile_action_tile.dart';

class LogoutActionTile extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutActionTile({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileActionTile(
      title: 'تسجيل الخروج',
      subtitle: 'سيتم إنهاء الجلسة الحالية والعودة إلى شاشة الدخول.',
      icon: Icons.logout_rounded,
      isDestructive: true,
      onTap: onTap,
    );
  }
}