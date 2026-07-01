import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_bloc/locale_bloc.dart';
import '../../../../core/localization/locale_bloc/locale_event.dart';
import '../../../../core/localization/locale_bloc/locale_state.dart';
import '../../../../core/localization/widgets/language_sheet.dart';
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

  Future<void> _handleLanguageTap(String currentLanguageCode) async {
    final selectedLanguage = await showLanguageSelectionSheet(
      context: context,
      currentLanguageCode: currentLanguageCode,
    );

    if (selectedLanguage == null) return;
    if (!mounted) return;

    context.read<LocaleBloc>().add(
      LanguageChanged(selectedLanguage),
    );
  }

  Future<void> _handleLogoutTap() async {
    final shouldLogout = await showLogoutConfirmationDialog(context);

    if (!shouldLogout || !mounted) return;

    _showMessage('تم تنفيذ تسجيل الخروج بشكل تجريبي.');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
            const SizedBox(height: 20),
            ProfileHeaderSection(
              profile: _profile,
              onEditProfileTap: _goToEditProfile,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final isDarkMode = themeState.themeMode == ThemeMode.dark;

                return BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (context, localeState) {
                    final languageCode = localeState.locale.languageCode;

                    return ProfilePreferencesSection(
                      isDarkModeEnabled: isDarkMode,
                      languageCode: languageCode,
                      onThemeChanged: _changeTheme,
                      onLanguageTap: () => _handleLanguageTap(languageCode),
                    );
                  },
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