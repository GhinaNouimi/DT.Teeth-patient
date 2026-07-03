import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../widgets/edit_profile_field.dart';
import '../widgets/edit_profile_gender_selector.dart';
import '../widgets/edit_profile_readonly_field.dart';
import '../widgets/edit_profile_section_card.dart';

class EditProfileBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dateOfBirthController;
  final TextEditingController addressController;
  final int gender;
  final bool enabled;
  final ValueChanged<int> onGenderChanged;

  const EditProfileBasicInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.dateOfBirthController,
    required this.addressController,
    required this.gender,
    required this.enabled,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return EditProfileSectionCard(
      title: l10n.profileBasicInfo,
      child: Column(
        children: [
          EditProfileField(
            label: l10n.fullName,
            controller: nameController,
            enabled: enabled,
          ),
          EditProfileReadOnlyField(
            label: l10n.email,
            value: emailController.text,
          ),
          EditProfileField(
            label: l10n.phoneNumber,
            controller: phoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
          ),
          EditProfileField(
            label: l10n.birthDate,
            controller: dateOfBirthController,
            enabled: enabled,
          ),
          EditProfileField(
            label: l10n.address,
            controller: addressController,
            enabled: enabled,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          EditProfileGenderSelector(
            selectedGender: gender,
            enabled: enabled,
            onChanged: onGenderChanged,
          ),
        ],
      ),
    );
  }
}