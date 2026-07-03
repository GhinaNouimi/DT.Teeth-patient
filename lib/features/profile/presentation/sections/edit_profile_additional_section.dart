import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
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
  final bool isFemale;
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
    required this.isFemale,
    required this.onPregnantChanged,
    required this.onBreastfeedingChanged,
    required this.onSmokerChanged,
    required this.onAlcoholChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return EditProfileSectionCard(
      title: l10n.profileAdditionalInfo,
      child: Column(
        children: [
          EditProfileField(
            label: l10n.teethCleaningFrequency,
            controller: teethCleaningController,
            enabled: enabled,
          ),
          const SizedBox(height: 6),

          if (isFemale) ...[
            EditProfileSwitchTile(
              title: l10n.isPregnant,
              value: isPregnant,
              enabled: enabled,
              onChanged: onPregnantChanged,
            ),
            EditProfileSwitchTile(
              title: l10n.isBreastfeeding,
              value: isBreastfeeding,
              enabled: enabled,
              onChanged: onBreastfeedingChanged,
            ),
          ],

          EditProfileSwitchTile(
            title: l10n.doYouSmoke,
            value: isSmoker,
            enabled: enabled,
            onChanged: onSmokerChanged,
          ),
          EditProfileSwitchTile(
            title: l10n.drinkAlcohol,
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