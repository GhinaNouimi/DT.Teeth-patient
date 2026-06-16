import 'package:flutter/material.dart';

import '../widgets/edit_profile_field.dart';
import '../widgets/edit_profile_section_card.dart';
import '../widgets/edit_profile_switch_tile.dart';

class EditProfileAdditionalSection extends StatelessWidget {
  final TextEditingController teethCleaningController;
  final bool isPregnant;
  final bool isBreastfeeding;
  final bool isSmoker;
  final bool drinksAlcoholFrequently;
  final bool enabled;
  final ValueChanged<bool> onPregnantChanged;
  final ValueChanged<bool> onBreastfeedingChanged;
  final ValueChanged<bool> onSmokerChanged;
  final ValueChanged<bool> onAlcoholChanged;

  const EditProfileAdditionalSection({
    super.key,
    required this.teethCleaningController,
    required this.isPregnant,
    required this.isBreastfeeding,
    required this.isSmoker,
    required this.drinksAlcoholFrequently,
    required this.enabled,
    required this.onPregnantChanged,
    required this.onBreastfeedingChanged,
    required this.onSmokerChanged,
    required this.onAlcoholChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EditProfileSectionCard(
      title: 'معلومات إضافية',
      child: Column(
        children: [
          EditProfileField(
            label: 'معدل تنظيف الأسنان',
            controller: teethCleaningController,
            enabled: enabled,
          ),
          const SizedBox(height: 6),
          EditProfileSwitchTile(
            title: 'حامل',
            value: isPregnant,
            enabled: enabled,
            onChanged: onPregnantChanged,
          ),
          EditProfileSwitchTile(
            title: 'مرضعة',
            value: isBreastfeeding,
            enabled: enabled,
            onChanged: onBreastfeedingChanged,
          ),
          EditProfileSwitchTile(
            title: 'مدخن',
            value: isSmoker,
            enabled: enabled,
            onChanged: onSmokerChanged,
          ),
          EditProfileSwitchTile(
            title: 'يشرب الكحول بكثرة',
            value: drinksAlcoholFrequently,
            enabled: enabled,
            onChanged: onAlcoholChanged,
            hasDivider: false,
          ),
        ],
      ),
    );
  }
}