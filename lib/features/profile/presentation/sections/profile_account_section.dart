import 'package:flutter/material.dart';

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
    return ProfileSectionCard(
      title: 'الحساب والدعم',
      child: Column(
        children: [
          ProfileActionTile(
            title: 'الشكاوى والدعم',
            subtitle: 'أرسل شكوى أو تواصل مع الدعم عند الحاجة.',
            icon: Icons.chat_bubble_outline_rounded,
            onTap: onComplaintsTap,
          ),
          const SizedBox(height: 8),
          ProfileActionTile(
            title: 'تغيير كلمة المرور',
            subtitle: 'حدّث كلمة المرور للحفاظ على أمان حسابك.',
            icon: Icons.lock_outline_rounded,
            onTap: onChangePasswordTap,
          ),
          const SizedBox(height: 14),
          LogoutActionTile(
            onTap: onLogoutTap,
          ),
          const SizedBox(height: 14),

        ],
      ),
    );
  }
}