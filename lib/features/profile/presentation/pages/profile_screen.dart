import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/connectivity/connectivity_bloc.dart';
import '../../../../core/connectivity/connectivity_state.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_bloc/locale_bloc.dart';
import '../../../../core/localization/locale_bloc/locale_event.dart';
import '../../../../core/localization/locale_bloc/locale_state.dart';
import '../../../../core/localization/widgets/language_sheet.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../../core/theme/theme_bloc/theme_event.dart';
import '../../../../core/theme/theme_bloc/theme_state.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../auth/presentation/bloc/logout/logout_bloc.dart';
import '../../../auth/presentation/bloc/logout/logout_event.dart';
import '../../../auth/presentation/bloc/logout/logout_state.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
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
  bool _isOfflineBannerDismissed = false;

  ProfileEntity _fakeProfile(String languageCode) {
    return ProfileEntity(
      id: '',
      userId: '',
      name: 'Patient Name',
      email: 'patient@email.com',
      phone: '0000000000',
      dateOfBirth: '',
      gender: 1,
      address: '',
      profilePicture: '',
      emergencyContactName: '',
      emergencyContactRelation: '',
      emergencyContactPhone: '',
      isPregnant: false,
      isBreastfeeding: false,
      isSmoker: false,
      drinksAlcoholFrequently: false,
      teethCleaningFrequency: '',
      allergies: const [],
      chronicDiseases: const [],
      medications: const [],
      isDarkModeEnabled: false,
      languageCode: languageCode,
    );
  }

  Future<void> _handleLanguageTap(
      BuildContext context,
      String currentLanguageCode,
      ) async {
    final selectedLanguage = await showLanguageSelectionSheet(
      context: context,
      currentLanguageCode: currentLanguageCode,
    );

    if (selectedLanguage == null || !context.mounted) return;

    context.read<LocaleBloc>().add(LanguageChanged(selectedLanguage));
  }

  Future<void> _handleLogoutTap(BuildContext context) async {
    final languageCode = Localizations.localeOf(context).languageCode;

    final shouldLogout = await showLogoutConfirmationDialog(context);

    if (!shouldLogout || !context.mounted) return;

    context.read<LogoutBloc>().add(
      LogoutRequested(languageCode: languageCode),
    );
  }

  void _reloadProfile(BuildContext context) {
    context.read<ProfileBloc>().add(
      LoadProfileRequested(
        languageCode: Localizations.localeOf(context).languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, connectivityState) {
            if (connectivityState is ConnectivityOffline) {
              setState(() {
                _isOfflineBannerDismissed = false;
              });
            }

            if (connectivityState is ConnectivityOnline) {
              final profileState = context.read<ProfileBloc>().state;

              if (profileState is ProfileLoaded &&
                  profileState.isFromCache) {
                setState(() {
                  _isOfflineBannerDismissed = false;
                });

                _reloadProfile(context);
              }
            }
          },
        ),
        BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) async {
            if (state is LogoutSuccess) {
              await showSuccessBottomSheet(
                context,
                title: l10n.logout,
                message: l10n.logoutSuccess,
                buttonText: l10n.ok,
              );

              if (!context.mounted) return;
              context.go(AppRoutes.login);
            }

            if (state is LogoutFailure) {
              await showErrorBottomSheet(
                context,
                title: l10n.logoutFailed,
                message: state.message,
                buttonText: l10n.ok,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              final isLoading = profileState is ProfileLoading ||
                  profileState is ProfileInitial;

              if (profileState is ProfileFailure) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => _reloadProfile(context),
                    child: Text(l10n.retry),
                  ),
                );
              }

              final profile = profileState is ProfileLoaded
                  ? profileState.profile
                  : profileState is ProfileUpdateSuccess
                  ? profileState.profile
                  : _fakeProfile(languageCode);

              final isFromCache = profileState is ProfileLoaded &&
                  profileState.isFromCache;

              final showOfflineBanner =
                  isFromCache && !_isOfflineBannerDismissed;

              return AppSkeleton(
                enabled: isLoading,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: showOfflineBanner
                          ? Padding(
                        key: const ValueKey('offline_banner'),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          14,
                          20,
                          0,
                        ),
                        child: OfflineCachedBanner(
                          message: l10n.offlineCachedDataMessage,
                          onClose: () {
                            setState(() {
                              _isOfflineBannerDismissed = true;
                            });
                          },
                        ),
                      )
                          : const SizedBox.shrink(
                        key: ValueKey('no_offline_banner'),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          20,
                          20,
                          20,
                          MediaQuery.of(context).padding.bottom + 110,
                        ),
                        children: [
                          ProfileHeaderSection(
                            profile: profile,
                            onEditProfileTap: isLoading
                                ? () {}
                                : () async {
                              final updatedProfile = await context.push(
                                AppRoutes.editProfile,
                                extra: profile,
                              );

                              if (!context.mounted) return;

                              if (updatedProfile != null) {
                                _reloadProfile(context);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<ThemeBloc, ThemeState>(
                            builder: (context, themeState) {
                              final isDarkMode =
                                  themeState.themeMode == ThemeMode.dark;

                              return BlocBuilder<LocaleBloc, LocaleState>(
                                builder: (context, localeState) {
                                  final currentLanguageCode =
                                      localeState.locale.languageCode;

                                  return ProfilePreferencesSection(
                                    isDarkModeEnabled: isDarkMode,
                                    languageCode: currentLanguageCode,
                                    onThemeChanged: (value) {
                                      context.read<ThemeBloc>().add(
                                        ThemeChanged(
                                          value
                                              ? ThemeMode.dark
                                              : ThemeMode.light,
                                        ),
                                      );
                                    },
                                    onLanguageTap: () {
                                      _handleLanguageTap(
                                        context,
                                        currentLanguageCode,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<LogoutBloc, LogoutState>(
                            builder: (context, logoutState) {
                              final isLogoutLoading =
                              logoutState is LogoutLoading;

                              return IgnorePointer(
                                ignoring: isLogoutLoading || isLoading,
                                child: Opacity(
                                  opacity: isLogoutLoading ? 0.55 : 1,
                                  child: ProfileAccountSection(
                                    onComplaintsTap: () {
                                      context.push(AppRoutes.complaints);
                                    },
                                    onChangePasswordTap: () {},
                                    onLogoutTap: () =>
                                        _handleLogoutTap(context),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}