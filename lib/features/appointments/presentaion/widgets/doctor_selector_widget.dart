import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_booking_dentist_entity.dart';

class DoctorSelectorWidget extends StatelessWidget {
  final List<AppointmentBookingDentistEntity> dentists;
  final AppointmentBookingDentistEntity? selectedDentist;
  final ValueChanged<AppointmentBookingDentistEntity>
  onDoctorSelected;
  final String languageCode;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const DoctorSelectorWidget({
    super.key,
    required this.dentists,
    required this.selectedDentist,
    required this.onDoctorSelected,
    required this.languageCode,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectDentistTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const _DoctorsLoadingView()
        else if (_hasError)
          _DoctorsErrorView(
            message: errorMessage!,
            onRetry: onRetry,
          )
        else if (dentists.isEmpty)
            _DoctorsEmptyView(
              message: l10n.noDentistsAvailableForAppointmentType,
            )
          else
            Column(
              children: dentists.map((dentist) {
                final isSelected =
                    selectedDentist?.id == dentist.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DoctorCard(
                    dentist: dentist,
                    languageCode: languageCode,
                    isSelected: isSelected,
                    onTap: () => onDoctorSelected(dentist),
                  ),
                );
              }).toList(),
            ),
      ],
    );
  }

  bool get _hasError {
    return errorMessage != null &&
        errorMessage!.trim().isNotEmpty;
  }
}

class _DoctorCard extends StatelessWidget {
  final AppointmentBookingDentistEntity dentist;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.dentist,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final specialization =
    dentist.localizedSpecialization(
      languageCode,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.buttonPrimary.withValues(
              alpha: 0.08,
            )
                : colors.surfacePrimary,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? colors.buttonPrimary
                  : colors.borderSoft,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: colors.buttonPrimary
                    .withValues(alpha: 0.16),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DoctorAvatar(
                imageUrl: dentist.profilePicture,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      dentist.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (specialization.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        specialization,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _DoctorMetaItem(
                          icon: Icons.star_rounded,
                          value: dentist.averageRating
                              .toStringAsFixed(1),
                        ),
                        _DoctorMetaItem(
                          icon: Icons.workspace_premium_outlined,
                          value: l10n.dentistYearsOfExperience(
                            dentist.yearsOfExperience,
                          ),
                        ),
                      ],
                    ),
                    if (dentist.hasBio) ...[
                      const SizedBox(height: 8),
                      Text(
                        dentist.bio!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(
                          color: colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: isSelected
                    ? Icon(
                  Icons.check_circle_rounded,
                  key: const ValueKey(
                    'selected_dentist',
                  ),
                  color: colors.buttonPrimary,
                  size: 25,
                )
                    : Icon(
                  Icons.radio_button_unchecked_rounded,
                  key: const ValueKey(
                    'unselected_dentist',
                  ),
                  color: colors.borderSoft,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? imageUrl;

  const _DoctorAvatar({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedImageUrl = imageUrl?.trim();

    final hasImage = normalizedImageUrl != null &&
        normalizedImageUrl.isNotEmpty;

    return CircleAvatar(
      radius: 29,
      backgroundColor: colors.surfaceMuted,
      child: ClipOval(
        child: hasImage
            ? CachedNetworkImage(
          imageUrl: normalizedImageUrl,
          width: 58,
          height: 58,
          fit: BoxFit.cover,
          placeholder: (
              context,
              imageUrl,
              ) {
            return SizedBox(
              width: 58,
              height: 58,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.buttonPrimary,
                ),
              ),
            );
          },
          errorWidget: (
              context,
              imageUrl,
              error,
              ) {
            return _FallbackDoctorAvatar(
              color: colors.buttonPrimary,
            );
          },
        )
            : _FallbackDoctorAvatar(
          color: colors.buttonPrimary,
        ),
      ),
    );
  }
}

class _FallbackDoctorAvatar extends StatelessWidget {
  final Color color;

  const _FallbackDoctorAvatar({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Icon(
        Icons.person_rounded,
        color: color,
        size: 30,
      ),
    );
  }
}

class _DoctorMetaItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const _DoctorMetaItem({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: icon == Icons.star_rounded
              ? const Color(0xFFFFC107)
              : colors.buttonPrimary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DoctorsLoadingView extends StatelessWidget {
  const _DoctorsLoadingView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 98,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorsEmptyView extends StatelessWidget {
  final String message;

  const _DoctorsEmptyView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 36,
            color: colors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _DoctorsErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .error
            .withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .error
              .withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 34,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
              height: 1.5,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                l10n.retryButton,
              ),
            ),
          ],
        ],
      ),
    );
  }
}