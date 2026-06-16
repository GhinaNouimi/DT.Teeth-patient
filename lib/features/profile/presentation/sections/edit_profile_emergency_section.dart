import 'package:flutter/material.dart';

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
    return EditProfileSectionCard(
      title: 'جهة الاتصال للطوارئ',
      child: Column(
        children: [
          EditProfileField(
            label: 'الاسم',
            controller: emergencyNameController,
            enabled: enabled,
          ),
          EditProfileField(
            label: 'صلة القرابة',
            controller: emergencyRelationController,
            enabled: enabled,
          ),
          EditProfileField(
            label: 'رقم الهاتف',
            controller: emergencyPhoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}