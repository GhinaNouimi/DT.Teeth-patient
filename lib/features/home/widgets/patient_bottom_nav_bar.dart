import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PatientBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            backgroundColor: colors.surfacePrimary,
            indicatorColor: colors.surfaceMuted,
            elevation: 0,
            height: 74,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? colors.navBarItem : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              );
            }),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.bottomNavHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.medical_services_outlined),
                selectedIcon: const Icon(Icons.medical_services_rounded),
                label: l10n.bottomNavDoctors,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month_rounded),
                label: l10n.bottomNavAppointments,
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_open_outlined),
                selectedIcon: const Icon(Icons.folder_rounded),
                label: l10n.bottomNavMedicalRecord,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: l10n.bottomNavAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
