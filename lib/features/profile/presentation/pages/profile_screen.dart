import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../../core/theme/theme_bloc/theme_event.dart';
import '../../../../core/theme/theme_bloc/theme_state.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/profile_entity.dart';
import '../dialogs/logout_dialog.dart';
import '../sections/profile_account_section.dart';
import '../sections/profile_header_section.dart';
import '../sections/profile_preferences_section.dart';
import '../sheets/language_sheet.dart';

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
    _profile = _initialProfile;
  }

  ProfileEntity get _initialProfile {
    return const ProfileEntity(
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

  void _goToEditProfile() {
    context.push(
      AppRoutes.editProfile,
      extra: _profile,
    );
  }

  void _changeTheme(bool isDarkModeEnabled) {
    context.read<ThemeBloc>().add(
      ThemeChanged(
        isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> _handleLanguageTap() async {
    final selectedLanguage = await showLanguageSelectionSheet(
      context: context,
      currentLanguageCode: _profile.languageCode,
    );

    if (selectedLanguage == null) return;

    setState(() {
      _profile = _profile.copyWith(languageCode: selectedLanguage);
    });
  }

  Future<void> _handleLogoutTap() async {
    final shouldLogout = await showLogoutConfirmationDialog(context);

    if (!shouldLogout || !mounted) return;

    _showMessage('تم تنفيذ تسجيل الخروج بشكل تجريبي.');
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
            3,
            20,
            MediaQuery.of(context).padding.bottom + 110,
          ),
          children: [
            // _ProfilePageTitle(theme: theme),
            const SizedBox(height: 20),
            ProfileHeaderSection(
              profile: _profile,
              onEditProfileTap: _goToEditProfile,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final isDarkMode = themeState.themeMode == ThemeMode.dark;

                return ProfilePreferencesSection(
                  isDarkModeEnabled: isDarkMode,
                  languageCode: _profile.languageCode,
                  onThemeChanged: _changeTheme,
                  onLanguageTap: _handleLanguageTap,
                );
              },
            ),
            const SizedBox(height: 16),
            ProfileAccountSection(
              onComplaintsTap: () {
                context.push(AppRoutes.complaints);
              },
              onChangePasswordTap: () {
                _showMessage('سيتم إضافة تغيير كلمة المرور لاحقًا.');
              },
              onLogoutTap: _handleLogoutTap,
            ),
          ],
        ),
      ),
    );
  }
}

// class _ProfilePageTitle extends StatelessWidget {
//   final ThemeData theme;
//
//   const _ProfilePageTitle({
//     required this.theme,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'حسابي',
//           style: theme.textTheme.headlineMedium?.copyWith(
//             color: colors.textPrimary,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'إدارة ملفك الشخصي، التفضيلات، وإعدادات الحساب من مكان واحد.',
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: colors.textSecondary,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
// }