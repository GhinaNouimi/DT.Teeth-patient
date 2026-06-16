import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/profile_entity.dart';
import '../widgets/profile_avatar_card.dart';

class ProfileHeaderSection extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEditProfileTap;

  const ProfileHeaderSection({
    super.key,
    required this.profile,
    required this.onEditProfileTap,
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
              ProfileAvatarCard(
                name: profile.name,
                avatarStyleId: profile.avatarStyleId,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ملف المريض',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoBadge(
                          icon: Icons.email_outlined,
                          label: profile.email,
                        ),
                        _InfoBadge(
                          icon: Icons.phone_outlined,
                          label: profile.phone,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: onEditProfileTap,
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                minimumSize: Size.zero,
                side: BorderSide(color: colors.borderSoft),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: colors.surfacePrimary,
              ),
              icon: Icon(
                Icons.edit_outlined,
                size: 16,
                color: colors.navBarItem,
              ),
              label: Text(
                'تعديل البروفايل',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.navBarItem,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: colors.navBarItem,
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 170),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}