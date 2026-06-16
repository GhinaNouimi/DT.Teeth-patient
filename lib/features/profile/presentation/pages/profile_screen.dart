import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/profile_entity.dart';
import '../sections/profile_account_section.dart';
import '../sections/profile_header_section.dart';
import '../sections/profile_preferences_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileEntity _profile;

  @override
  void initState() {
    super.initState();
    _profile = const ProfileEntity(
      id: 'profile-001',
      name: 'نور الهدى أحمد',
      email: 'noor.ahmad@example.com',
      phone: '+963 944 123 456',
      dateOfBirth: '14 يونيو 1998',
      gender: 0,
      address: 'دمشق - المزة',
      emergencyContactName: 'أحمد خالد',
      emergencyContactRelation: 'الأب',
      emergencyContactPhone: '+963 933 000 111',
      isPregnant: false,
      isBreastfeeding: false,
      isSmoker: false,
      drinksAlcoholFrequently: false,
      teethCleaningFrequency: 'مرتان يوميًا',
      avatarStyleId: 'female_1',
      isDarkModeEnabled: false,
      languageCode: 'ar',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showLanguageSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colors = context.colors;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختيار اللغة',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => Navigator.of(context).pop('ar'),
                title: const Text('العربية'),
                trailing: _profile.languageCode == 'ar'
                    ? Icon(Icons.check_circle, color: colors.success)
                    : null,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => Navigator.of(context).pop('en'),
                title: const Text('English'),
                trailing: _profile.languageCode == 'en'
                    ? Icon(Icons.check_circle, color: colors.success)
                    : null,
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _profile = _profile.copyWith(languageCode: selected);
      });
    }
  }

  Future<void> _showLogoutDialog() async {
    final colors = context.colors;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: colors.textInverse,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      _showMessage('تم تنفيذ تسجيل الخروج بشكل تجريبي.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).padding.bottom + 110,
          ),          children: [
            Text(
              'حسابي',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'إدارة ملفك الشخصي، التفضيلات، وإعدادات الحساب من مكان واحد.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ProfileHeaderSection(
              profile: _profile,
              onEditProfileTap: () {
                context.push(
                  AppRoutes.editProfile,
                  extra: _profile,
                );
              },
            ),
            const SizedBox(height: 16),
            ProfilePreferencesSection(
              profile: _profile,
              onThemeChanged: (value) {
                setState(() {
                  _profile = _profile.copyWith(isDarkModeEnabled: value);
                });
              },
              onLanguageTap: _showLanguageSheet,
            ),
            const SizedBox(height: 16),
            ProfileAccountSection(
              onComplaintsTap: () {
                _showMessage('سيتم إضافة الشكاوى والدعم لاحقًا.');
              },
              onChangePasswordTap: () {
                _showMessage('سيتم إضافة تغيير كلمة المرور لاحقًا.');
              },
              onLogoutTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }
}