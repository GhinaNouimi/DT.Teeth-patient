import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_type_entity.dart';

class AppointmentTypeSelectorWidget extends StatelessWidget {
  final List<AppointmentTypeEntity> appointmentTypes;
  final AppointmentTypeEntity? selectedType;
  final ValueChanged<AppointmentTypeEntity> onTypeSelected;
  final String languageCode;

  const AppointmentTypeSelectorWidget({
    super.key,
    required this.appointmentTypes,
    required this.selectedType,
    required this.onTypeSelected,
    required this.languageCode,
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
          l10n.appointmentTypeLabel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (appointmentTypes.isEmpty)
          _EmptyAppointmentTypesView(
            message: l10n.noAppointmentTypesAvailable,
          )
        else
          Column(
            children: appointmentTypes.map((type) {
              final isSelected =
                  selectedType?.id == type.id;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _AppointmentTypeCard(
                  type: type,
                  languageCode: languageCode,
                  isSelected: isSelected,
                  onTap: () {
                    onTypeSelected(type);
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _AppointmentTypeCard extends StatelessWidget {
  final AppointmentTypeEntity type;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppointmentTypeCard({
    required this.type,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final localizedName = type.localizedName(
      languageCode,
    );

    final selectedColor = colors.buttonPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor
                : colors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? selectedColor
                  : colors.borderSoft,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: selectedColor.withValues(
                  alpha: 0.22,
                ),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  localizedName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white
                        : colors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey(
                    'selected_appointment_type',
                  ),
                  color: Colors.white,
                  size: 25,
                )
                    : Icon(
                  Icons.radio_button_unchecked_rounded,
                  key: const ValueKey(
                    'unselected_appointment_type',
                  ),
                  color: colors.textSecondary
                      .withValues(alpha: 0.45),
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAppointmentTypesView
    extends StatelessWidget {
  final String message;

  const _EmptyAppointmentTypesView({
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
            Icons.event_busy_outlined,
            size: 34,
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