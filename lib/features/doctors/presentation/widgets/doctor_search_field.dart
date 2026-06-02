import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class DoctorSearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const DoctorSearchFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<DoctorSearchFieldWidget> createState() =>
      _DoctorSearchFieldWidgetState();
}

class _DoctorSearchFieldWidgetState extends State<DoctorSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'ابحث عن طبيب...',
        prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
        suffixIcon: widget.controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  widget.onChanged('');
                },
                child: Icon(Icons.close_rounded, color: colors.textSecondary),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.borderSoft),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(DoctorSearchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
}
