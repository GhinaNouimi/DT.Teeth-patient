import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_section_card.dart';

class ProfilePersonalInfoSection extends StatelessWidget {
  final ProfileEntity profile;

  const ProfilePersonalInfoSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'المعلومات الشخصية',
      child: Column(
        children: [
          ProfileInfoTile(
            label: 'البريد الإلكتروني',
            value: profile.email,
            icon: Icons.email_outlined,
          ),
          ProfileInfoTile(
            label: 'رقم الهاتف',
            value: profile.phone,
            icon: Icons.phone_outlined,
          ),
          ProfileInfoTile(
            label: 'تاريخ الميلاد',
            value: profile.dateOfBirth,
            icon: Icons.cake_outlined,
          ),
          ProfileInfoTile(
            label: 'الجنس',
            value: profile.genderLabel,
            icon: Icons.person_outline_rounded,
          ),
          ProfileInfoTile(
            label: 'العنوان',
            value: profile.address,
            icon: Icons.location_on_outlined,
          ),
          ProfileInfoTile(
            label: 'جهة اتصال للطوارئ',
            value:
            '${profile.emergencyContactName} - ${profile.emergencyContactRelation}',
            icon: Icons.contact_emergency_outlined,
          ),
          ProfileInfoTile(
            label: 'هاتف الطوارئ',
            value: profile.emergencyContactPhone,
            icon: Icons.local_phone_outlined,
          ),
          ProfileInfoTile(
            label: 'تنظيف الأسنان',
            value: profile.teethCleaningFrequency,
            icon: Icons.cleaning_services_outlined,
          ),
        ],
      ),
    );
  }
}