import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentBookingTypeSelectorWidget
    extends StatelessWidget {
  final AppointmentBookingType? selectedBookingType;

  final ValueChanged<AppointmentBookingType>
  onBookingTypeSelected;

  final bool enableContinueTreatment;

  const AppointmentBookingTypeSelectorWidget({
    super.key,
    required this.selectedBookingType,
    required this.onBookingTypeSelected,
    this.enableContinueTreatment = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final options = <_BookingTypeOption>[
      _BookingTypeOption(
        type: AppointmentBookingType.newTreatment,
        title: l10n.newTreatmentBookingTitle,
        description:
        l10n.newTreatmentBookingDescription,
        icon: Icons.add_circle_outline_rounded,
      ),
      _BookingTypeOption(
        type:
        AppointmentBookingType.continueTreatment,
        title: l10n.continueTreatmentBookingTitle,
        description:
        l10n.continueTreatmentBookingDescription,
        icon: Icons.replay_circle_filled_outlined,
        enabled: enableContinueTreatment,
      ),
      _BookingTypeOption(
        type: AppointmentBookingType.emergency,
        title: l10n.emergencyBookingTitle,
        description:
        l10n.emergencyBookingDescription,
        icon: Icons.emergency_rounded,
        isEmergency: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectBookingTypeTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.selectBookingTypeDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: options.map((option) {
            final isSelected =
                selectedBookingType == option.type;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: _BookingTypeCard(
                option: option,
                isSelected: isSelected,
                onTap: option.enabled
                    ? () {
                  onBookingTypeSelected(
                    option.type,
                  );
                }
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BookingTypeCard extends StatelessWidget {
  final _BookingTypeOption option;
  final bool isSelected;
  final VoidCallback? onTap;

  const _BookingTypeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final accentColor = option.isEmergency
        ? colors.danger
        : colors.buttonPrimary;

    final isEnabled = option.enabled;

    final backgroundColor = isSelected
        ? accentColor.withValues(alpha: 0.10)
        : colors.surfacePrimary;

    final borderColor = isSelected
        ? accentColor
        : colors.borderSoft;

    return AnimatedOpacity(
      duration: const Duration(
        milliseconds: 180,
      ),
      opacity: isEnabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: accentColor.withValues(
                    alpha: 0.14,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(
                      alpha: isSelected
                          ? 0.16
                          : 0.10,
                    ),
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: Icon(
                    option.icon,
                    color: accentColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: theme
                            .textTheme.titleSmall
                            ?.copyWith(
                          color: colors.textPrimary,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        option.description,
                        style: theme
                            .textTheme.bodySmall
                            ?.copyWith(
                          color:
                          colors.textSecondary,
                          height: 1.5,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                      if (!isEnabled) ...[
                        const SizedBox(height: 7),
                        Text(
                          context.l10n
                              .continueTreatmentUnavailableMessage,
                          style: theme
                              .textTheme.bodySmall
                              ?.copyWith(
                            color:
                            colors.textSecondary,
                            fontWeight:
                            FontWeight.w700,
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
                    key: ValueKey(
                      'selected_${option.type.name}',
                    ),
                    color: accentColor,
                    size: 26,
                  )
                      : Icon(
                    Icons
                        .radio_button_unchecked_rounded,
                    key: ValueKey(
                      'unselected_${option.type.name}',
                    ),
                    color: colors.borderSoft,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingTypeOption {
  final AppointmentBookingType type;
  final String title;
  final String description;
  final IconData icon;
  final bool isEmergency;
  final bool enabled;

  const _BookingTypeOption({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.isEmergency = false,
    this.enabled = true,
  });
}