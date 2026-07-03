import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
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

  File? _selectedProfilePicture;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fillControllers(widget.profile);
  }

  void _fillControllers(ProfileEntity profile) {
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
    _selectedProfilePicture = null;
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

  Future<void> _pickProfilePicture() async {
    if (!_isEditing) return;

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _selectedProfilePicture = File(image.path);
    });
  }

  Future<bool> _confirmSave() async {
    final l10n = context.l10n;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.confirmSave),
          content: Text(l10n.confirmSaveMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _saveProfile() async {
    final shouldSave = await _confirmSave();
    if (!shouldSave || !mounted) return;

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      dateOfBirth: _dateOfBirthController.text.trim(),
      gender: _gender,
      address: _addressController.text.trim(),
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactRelation: _emergencyRelationController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      isPregnant: _gender == 2 ? _isPregnant : false,
      isBreastfeeding: _gender == 2 ? _isBreastfeeding : false,
      isSmoker: _isSmoker,
      drinksAlcoholFrequently: _drinksAlcoholFrequently,
      teethCleaningFrequency: _teethCleaningController.text.trim(),
    );

    context.read<ProfileBloc>().add(
      UpdateProfileRequested(
        profile: updatedProfile,
        profilePicture: _selectedProfilePicture,
        languageCode: Localizations.localeOf(context).languageCode,

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileUpdateSuccess) {
          setState(() {
            _isEditing = false;
          });

          await showSuccessBottomSheet(
            context,
            title: l10n.savedSuccessfully,
            message: l10n.profileUpdatedSuccessfully,
            buttonText: l10n.excellent,
          );

          if (!context.mounted) return;
          Navigator.of(context).pop(state.profile);
        }

        if (state is ProfileFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.profileUpdateFailed,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final isSaving = state is ProfileUpdating;

          return Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: AppTopBar(
                      title: l10n.editProfile,
                      trailing: TextButton(
                        onPressed: isSaving ? null : _toggleEditMode,
                        child: Text(_isEditing ? l10n.cancel : l10n.edit),
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
                          profilePicture: widget.profile.profilePicture,
                          selectedProfilePicture: _selectedProfilePicture,
                          isEditing: _isEditing,
                          onChangePictureTap: _pickProfilePicture,
                        ),
                        const SizedBox(height: 16),
                        EditProfileBasicInfoSection(
                          nameController: _nameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          dateOfBirthController: _dateOfBirthController,
                          addressController: _addressController,
                          gender: _gender,
                          enabled: _isEditing && !isSaving,
                          onGenderChanged: (value) {
                            setState(() {
                              _gender = value;

                              if (_gender != 2) {
                                _isPregnant = false;
                                _isBreastfeeding = false;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        EditProfileEmergencySection(
                          emergencyNameController: _emergencyNameController,
                          emergencyRelationController:
                          _emergencyRelationController,
                          emergencyPhoneController: _emergencyPhoneController,
                          enabled: _isEditing && !isSaving,
                        ),
                        const SizedBox(height: 16),
                        EditProfileAdditionalSection(
                          teethCleaningController: _teethCleaningController,
                          isPregnant: _isPregnant,
                          isBreastfeeding: _isBreastfeeding,
                          isSmoker: _isSmoker,
                          drinksAlcoholFrequently: _drinksAlcoholFrequently,
                          enabled: _isEditing && !isSaving,
                          isFemale: _gender == 2,
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
                onPressed: isSaving ? null : _saveProfile,
                child: Text(
                  isSaving ? l10n.savingChanges : l10n.saveChanges,
                ),
              ),
            )
                : null,
          );
        },
      ),
    );
  }
}