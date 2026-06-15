import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

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
                  'الحساب والدعم',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 14),
          _AccountActionRow(
            title: 'الشكاوى والدعم',
            icon: Icons.chat_bubble_outline_rounded,
            onTap: onComplaintsTap,
          ),
          Divider(
            height: 20,
            color: colors.borderSoft.withValues(alpha: 0.75),
          ),
          _AccountActionRow(
            title: 'تغيير كلمة المرور',
            icon: Icons.lock_outline_rounded,
            onTap: onChangePasswordTap,
          ),
          Divider(
            height: 20,
            color: colors.borderSoft.withValues(alpha: 0.75),
          ),
          _AccountActionRow(
            title: 'تسجيل الخروج',
            icon: Icons.logout_rounded,
            color: colors.danger,
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}

class _AccountActionRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _AccountActionRow({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final effectiveColor = color ?? colors.navBarItem;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: effectiveColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: effectiveColor == colors.danger
                      ? colors.danger
                      : colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}