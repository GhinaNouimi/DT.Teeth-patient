import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/profile_entity.dart';
import '../../profile_di.dart';
import '../sections/edit_profile_additional_section.dart';
import '../sections/edit_profile_basic_info_section.dart';
import '../sections/edit_profile_emergency_section.dart';
import '../sections/edit_profile_hero_section.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _addressController;
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyRelationController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _teethCleaningController;

  late int _gender;
  late bool _isPregnant;
  late bool _isBreastfeeding;
  late bool _isSmoker;
  late bool _drinksAlcoholFrequently;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;

    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _dateOfBirthController = TextEditingController(text: profile.dateOfBirth);
    _addressController = TextEditingController(text: profile.address);
    _emergencyNameController =
        TextEditingController(text: profile.emergencyContactName);
    _emergencyRelationController =
        TextEditingController(text: profile.emergencyContactRelation);
    _emergencyPhoneController =
        TextEditingController(text: profile.emergencyContactPhone);
    _teethCleaningController =
        TextEditingController(text: profile.teethCleaningFrequency);

    _gender = profile.gender;
    _isPregnant = profile.isPregnant;
    _isBreastfeeding = profile.isBreastfeeding;
    _isSmoker = profile.isSmoker;
    _drinksAlcoholFrequently = profile.drinksAlcoholFrequently;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    _teethCleaningController.dispose();
    super.dispose();
  }

  void _resetForm() {
    final profile = widget.profile;

    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _dateOfBirthController.text = profile.dateOfBirth;
    _addressController.text = profile.address;
    _emergencyNameController.text = profile.emergencyContactName;
    _emergencyRelationController.text = profile.emergencyContactRelation;
    _emergencyPhoneController.text = profile.emergencyContactPhone;
    _teethCleaningController.text = profile.teethCleaningFrequency;

    _gender = profile.gender;
    _isPregnant = profile.isPregnant;
    _isBreastfeeding = profile.isBreastfeeding;
    _isSmoker = profile.isSmoker;
    _drinksAlcoholFrequently = profile.drinksAlcoholFrequently;
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        _resetForm();
        _isEditing = false;
      } else {
        _isEditing = true;
      }
    });
  }

  Future<bool> _confirmSave() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد الحفظ'),
          content: const Text('هل أنت متأكد أنك تريد حفظ التعديلات؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _saveProfile() async {
    final shouldSave = await _confirmSave();
    if (!shouldSave) return;

    setState(() => _isSaving = true);

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      dateOfBirth: _dateOfBirthController.text.trim(),
      gender: _gender,
      address: _addressController.text.trim(),
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactRelation: _emergencyRelationController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      isPregnant: _isPregnant,
      isBreastfeeding: _isBreastfeeding,
      isSmoker: _isSmoker,
      drinksAlcoholFrequently: _drinksAlcoholFrequently,
      teethCleaningFrequency: _teethCleaningController.text.trim(),
    );

    await ProfileDi.updateProfileUseCase(updatedProfile);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    await showSuccessBottomSheet(
      context,
      title: 'تم الحفظ بنجاح',
      message: 'تم تحديث بيانات البروفايل بنجاح.',
      buttonText: 'ممتاز',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'تعديل البروفايل',
                trailing: TextButton(
                  onPressed: _toggleEditMode,
                  child: Text(_isEditing ? 'إلغاء' : 'تعديل'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(context).padding.bottom + 110,
                ),
                children: [
                  EditProfileHeroSection(
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  EditProfileBasicInfoSection(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    dateOfBirthController: _dateOfBirthController,
                    addressController: _addressController,
                    gender: _gender,
                    enabled: _isEditing,
                    onGenderChanged: (value) {
                      setState(() => _gender = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  EditProfileEmergencySection(
                    emergencyNameController: _emergencyNameController,
                    emergencyRelationController: _emergencyRelationController,
                    emergencyPhoneController: _emergencyPhoneController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  EditProfileAdditionalSection(
                    teethCleaningController: _teethCleaningController,
                    isPregnant: _isPregnant,
                    isBreastfeeding: _isBreastfeeding,
                    isSmoker: _isSmoker,
                    drinksAlcoholFrequently: _drinksAlcoholFrequently,
                    enabled: _isEditing,
                    onPregnantChanged: (value) {
                      setState(() => _isPregnant = value);
                    },
                    onBreastfeedingChanged: (value) {
                      setState(() => _isBreastfeeding = value);
                    },
                    onSmokerChanged: (value) {
                      setState(() => _isSmoker = value);
                    },
                    onAlcoholChanged: (value) {
                      setState(() => _drinksAlcoholFrequently = value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing
          ? SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveProfile,
          child: Text(_isSaving ? 'جارٍ الحفظ...' : 'حفظ التعديلات'),
        ),
      )
          : null,
    );
  }
}