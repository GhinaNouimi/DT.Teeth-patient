// lib/features/appointments/presentation/widgets/appointment_type_selector_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/appointment_type.dart';
import '../models/appointment_ui_model.dart';

class AppointmentTypeSelectorWidget extends StatelessWidget {
  final AppointmentType? selectedType;
  final Function(AppointmentType) onTypeSelected;

  const AppointmentTypeSelectorWidget({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الموعد',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: AppointmentType.values.map((type) {
            final isSelected = selectedType == type;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AppointmentTypeCard(
                type: type,
                isSelected: isSelected,
                onTap: () => onTypeSelected(type),
                colors: colors,
                theme: theme,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AppointmentTypeCard extends StatelessWidget {
  final AppointmentType type;
  final bool isSelected;
  final VoidCallback onTap;
  final dynamic colors;
  final ThemeData theme;

  const _AppointmentTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.theme,
  });

  Color _getCardColor() {
    if (type == AppointmentType.emergency) {
      return isSelected ? const Color(0xFFE74C3C) : colors.surfaceMuted;
    }
    return isSelected ? colors.buttonPrimary : colors.surfaceMuted;
  }

  Color _getTextColor() {
    if (isSelected) {
      return Colors.white;
    }
    return type == AppointmentType.emergency
        ? const Color(0xFFE74C3C)
        : colors.textPrimary;
  }

  IconData _getIcon() {
    switch (type) {
      case AppointmentType.emergency:
        return Icons.emergency_rounded;
      case AppointmentType.regular:
        return Icons.calendar_month_rounded;
      case AppointmentType.followUp:
        return Icons.repeat_rounded;
    }
  }

  String _getDescription() {
    switch (type) {
      case AppointmentType.emergency:
        return 'موعد طارئ - سيتم معالجته فوراً';
      case AppointmentType.regular:
        return 'حجز موعد عادي';
      case AppointmentType.followUp:
        return 'موعد متابعة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getCardColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (type == AppointmentType.emergency
                ? const Color(0xFFE74C3C)
                : colors.buttonPrimary)
                : colors.borderSoft,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _getCardColor().withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              _getIcon(),
              color: _getTextColor(),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDescription(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getTextColor().withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: _getTextColor(),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}