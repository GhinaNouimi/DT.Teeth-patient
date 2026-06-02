// lib/features/appointments/presentation/widgets/service_type_grid_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/appointment_ui_model.dart';
import '../models/service_type.dart';

class ServiceTypeGridWidget extends StatelessWidget {
  final ServiceType? selectedService;
  final Function(ServiceType) onServiceSelected;

  const ServiceTypeGridWidget({
    super.key,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر نوع الخدمة',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: ServiceType.values.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final service = ServiceType.values[index];
            final isSelected = selectedService == service;

            return _ServiceTypeCard(
              service: service,
              isSelected: isSelected,
              onTap: () => onServiceSelected(service),
              colors: colors,
              theme: theme,
            );
          },
        ),
      ],
    );
  }
}

class _ServiceTypeCard extends StatelessWidget {
  final ServiceType service;
  final bool isSelected;
  final VoidCallback onTap;
  final dynamic colors;
  final ThemeData theme;

  const _ServiceTypeCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? colors.buttonPrimary : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.buttonPrimary : colors.borderSoft,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.buttonPrimary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                service.displayName,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? Colors.white : colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
