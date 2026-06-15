import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/profile_entity.dart';
import '../../profile_di.dart';

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

  Future<void> _saveProfile() async {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
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
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        _resetForm();
                        _isEditing = false;
                      } else {
                        _isEditing = true;
                      }
                    });
                  },
                  child: Text(_isEditing ? 'إلغاء' : 'تعديل'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  _ModeBanner(isEditing: _isEditing),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'البيانات الأساسية',
                    child: Column(
                      children: [
                        _ProfileRowField(
                          label: 'الاسم الكامل',
                          controller: _nameController,
                          enabled: _isEditing,
                        ),
                        _ProfileRowField(
                          label: 'البريد الإلكتروني',
                          controller: _emailController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _ProfileRowField(
                          label: 'رقم الهاتف',
                          controller: _phoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        _ProfileRowField(
                          label: 'تاريخ الميلاد',
                          controller: _dateOfBirthController,
                          enabled: _isEditing,
                        ),
                        _ProfileRowField(
                          label: 'العنوان',
                          controller: _addressController,
                          enabled: _isEditing,
                          maxLines: 2,
                          hasDivider: false,
                        ),
                        const SizedBox(height: 14),
                        _GenderSelector(
                          selectedGender: _gender,
                          enabled: _isEditing,
                          onChanged: (value) {
                            setState(() => _gender = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'جهة الاتصال للطوارئ',
                    child: Column(
                      children: [
                        _ProfileRowField(
                          label: 'الاسم',
                          controller: _emergencyNameController,
                          enabled: _isEditing,
                        ),
                        _ProfileRowField(
                          label: 'صلة القرابة',
                          controller: _emergencyRelationController,
                          enabled: _isEditing,
                        ),
                        _ProfileRowField(
                          label: 'رقم الهاتف',
                          controller: _emergencyPhoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          hasDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'معلومات إضافية',
                    child: Column(
                      children: [
                        _ProfileRowField(
                          label: 'معدل تنظيف الأسنان',
                          controller: _teethCleaningController,
                          enabled: _isEditing,
                          hasDivider: false,
                        ),
                        const SizedBox(height: 14),
                        _SwitchRow(
                          title: 'حامل',
                          value: _isPregnant,
                          enabled: _isEditing,
                          onChanged: (value) {
                            setState(() => _isPregnant = value);
                          },
                        ),
                        _SwitchRow(
                          title: 'مرضعة',
                          value: _isBreastfeeding,
                          enabled: _isEditing,
                          onChanged: (value) {
                            setState(() => _isBreastfeeding = value);
                          },
                        ),
                        _SwitchRow(
                          title: 'مدخن',
                          value: _isSmoker,
                          enabled: _isEditing,
                          onChanged: (value) {
                            setState(() => _isSmoker = value);
                          },
                        ),
                        _SwitchRow(
                          title: 'يشرب الكحول بكثرة',
                          value: _drinksAlcoholFrequently,
                          enabled: _isEditing,
                          onChanged: (value) {
                            setState(
                                  () => _drinksAlcoholFrequently = value,
                            );
                          },
                          hasDivider: false,
                        ),
                      ],
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: Text(
                          _isSaving ? 'جارٍ الحفظ...' : 'حفظ التعديلات',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeBanner extends StatelessWidget {
  final bool isEditing;

  const _ModeBanner({
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isEditing
            ? colors.surfaceSecondary
            : colors.surfaceMuted.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          Icon(
            isEditing ? Icons.edit_note_rounded : Icons.visibility_outlined,
            color: colors.navBarItem,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEditing
                  ? 'أنت الآن في وضع التعديل. يمكنك تحديث البيانات ثم حفظها.'
                  : 'أنت الآن في وضع الاستعراض. اضغط تعديل لتحديث البيانات.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProfileRowField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;
  final bool hasDivider;

  const _ProfileRowField({
    required this.label,
    required this.controller,
    required this.enabled,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: hasDivider
            ? Border(
          bottom: BorderSide(
            color: colors.borderSoft.withValues(alpha: 0.72),
          ),
        )
            : null,
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          isDense: true,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final int selectedGender;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    Widget item({
      required String label,
      required int value,
    }) {
      final isSelected = selectedGender == value;

      return Expanded(
        child: InkWell(
          onTap: enabled ? () => onChanged(value) : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.surfaceMuted
                  : colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colors.navBarItem.withValues(alpha: 0.14)
                    : colors.borderSoft,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجنس',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            item(label: 'ذكر', value: 1),
            const SizedBox(width: 10),
            item(label: 'أنثى', value: 0),
          ],
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final bool hasDivider;

  const _SwitchRow({
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: hasDivider
            ? Border(
          bottom: BorderSide(
            color: colors.borderSoft.withValues(alpha: 0.72),
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: colors.navBarItem,
            activeTrackColor: colors.surfaceMuted,
          ),
        ],
      ),
    );
  }
}