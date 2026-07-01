import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../generated/assets.dart';

class PatientWelcomeHeroSection extends StatelessWidget {
  const PatientWelcomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    const userName = 'Sarah';

    return Container(
      height: 190,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            colors.heroStart,
            colors.heroEnd,
          ],
        ),
        border: Border.all(color: colors.heroBorder),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        textDirection: Directionality.of(context),
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomePatient,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 42,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.push(AppRoutes.newAppointment);
                    },
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(l10n.bookAppointment),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.heroButton,
                      foregroundColor: colors.textInverse,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          Flexible(
            flex: 4,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 1.9,
                heightFactor: 1.9,
                child: Image.asset(
                  Assets.welcomeHero,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}