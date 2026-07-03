import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../widgets/edit_profile_field.dart';
import '../widgets/edit_profile_section_card.dart';

class EditProfileEmergencySection extends StatelessWidget {
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyRelationController;
  final TextEditingController emergencyPhoneController;
  final bool enabled;

  const EditProfileEmergencySection({
    super.key,
    required this.emergencyNameController,
    required this.emergencyRelationController,
    required this.emergencyPhoneController,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return EditProfileSectionCard(
      title: l10n.profileEmergencyContact,
      child: Column(
        children: [
          EditProfileField(
            label: l10n.emergencyContactName,
            controller: emergencyNameController,
            enabled: enabled,
          ),
          EditProfileField(
            label: l10n.emergencyContactRelation,
            controller: emergencyRelationController,
            enabled: enabled,
          ),
          EditProfileField(
            label: l10n.emergencyPhone,
            controller: emergencyPhoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}