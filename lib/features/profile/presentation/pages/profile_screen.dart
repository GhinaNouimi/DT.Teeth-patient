import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/profile_entity.dart';
import '../../profile_di.dart';
import '../sections/profile_account_section.dart';
import '../sections/profile_header_section.dart';
import '../sections/profile_preferences_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileEntity? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileDi.getProfileUseCase();
    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _updateTheme(bool value) async {
    final profile = _profile;
    if (profile == null) return;

    final updatedProfile = await ProfileDi.updateProfileUseCase(
      profile.copyWith(isDarkModeEnabled: value),
    );

    if (!mounted) return;

    setState(() {
      _profile = updatedProfile;
    });
  }

  void _showLanguageSheet() {
    final profile = _profile;
    if (profile == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colors = context.colors;
        final theme = Theme.of(context);

        Widget optionTile({
          required String label,
          required String code,
        }) {
          final isSelected = profile.languageCode == code;

          return InkWell(
            onTap: () async {
              final updatedProfile = await ProfileDi.updateProfileUseCase(
                profile.copyWith(languageCode: code),
              );

              if (!mounted) return;

              setState(() {
                _profile = updatedProfile;
              });

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.surfaceMuted
                    : colors.surfacePrimary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? colors.navBarItem.withValues(alpha: 0.14)
                      : colors.borderSoft,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: colors.navBarItem,
                    ),
                ],
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.borderSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'اختر اللغة',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              optionTile(label: 'العربية', code: 'ar'),
              const SizedBox(height: 10),
              optionTile(label: 'English', code: 'en'),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    final colors = context.colors;
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surfacePrimary,
          title: Text(
            'تسجيل الخروج',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'هل تريد تسجيل الخروج من الحساب الحالي؟',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الخروج بنجاح'),
                  ),
                );
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_profile == null)
            ? Center(
          child: Text(
            'تعذر تحميل بيانات الحساب',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
            : ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _ProfileTopBrandBar(profileName: _profile!.name),
            const SizedBox(height: 20),
            ProfileHeaderSection(
              profile: _profile!,
              onEditProfileTap: () {
                context.push(
                  AppRoutes.editProfile,
                  extra: _profile!,
                );
              },
            ),
            const SizedBox(height: 18),
            ProfilePreferencesSection(
              profile: _profile!,
              onThemeChanged: _updateTheme,
              onLanguageTap: _showLanguageSheet,
            ),
            const SizedBox(height: 18),
            ProfileAccountSection(
              onComplaintsTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم إضافة الشكاوى والدعم لاحقًا'),
                  ),
                );
              },
              onChangePasswordTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'سيتم إضافة تغيير كلمة المرور لاحقًا',
                    ),
                  ),
                );
              },
              onLogoutTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTopBrandBar extends StatelessWidget {
  final String profileName;

  const _ProfileTopBrandBar({
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: colors.navBarItem,
              ),
              PositionedDirectional(
                top: 10,
                end: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.buttonPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'DT.Teeth',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.navBarItem,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 52,
                height: 3,
                decoration: BoxDecoration(
                  color: colors.buttonPrimary.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSoft),
          ),

        ),
      ],
    );
  }
}