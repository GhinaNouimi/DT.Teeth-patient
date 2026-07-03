import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/full_screen_image_viewer.dart';
import '../widgets/edit_profile_status_badge.dart';

class EditProfileHeroSection extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final File? selectedProfilePicture;
  final bool isEditing;
  final VoidCallback onChangePictureTap;

  const EditProfileHeroSection({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.selectedProfilePicture,
    required this.isEditing,
    required this.onChangePictureTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              GestureDetector(
                onTap: () {
                  if (selectedProfilePicture == null && profilePicture.isEmpty) {
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imageUrl: selectedProfilePicture == null ? profilePicture : null,
                        imageFile: selectedProfilePicture,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: colors.surfaceSecondary,
                  child: ClipOval(
                    child: selectedProfilePicture != null
                        ? Image.file(
                      selectedProfilePicture!,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: profilePicture,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => SizedBox(
                        width: 76,
                        height: 76,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.navBarItem,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person_rounded,
                        size: 38,
                        color: colors.navBarItem,
                      ),
                    ),
                  ),
                ),
              ),
              if (isEditing)
                InkWell(
                  onTap: onChangePictureTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: colors.navBarItem,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.surfacePrimary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: colors.textInverse,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                EditProfileStatusBadge(
                  isEditing: isEditing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}