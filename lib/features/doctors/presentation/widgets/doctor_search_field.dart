import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class DoctorSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DoctorSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'ابحث عن طبيب أو تخصص',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colors.navBarItem,
        ),
        filled: true,
        fillColor: colors.surfacePrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
