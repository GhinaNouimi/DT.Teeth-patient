import 'package:flutter/material.dart';

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
    return EditProfileSectionCard(
      title: 'البيانات الأساسية',
      child: Column(
        children: [
          EditProfileField(
            label: 'الاسم الكامل',
            controller: nameController,
            enabled: enabled,
          ),
          EditProfileReadOnlyField(
            label: 'البريد الإلكتروني',
            value: emailController.text,
          ),
          EditProfileField(
            label: 'رقم الهاتف',
            controller: phoneController,
            enabled: enabled,
            keyboardType: TextInputType.phone,
          ),
          EditProfileField(
            label: 'تاريخ الميلاد',
            controller: dateOfBirthController,
            enabled: enabled,
          ),
          EditProfileField(
            label: 'العنوان',
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