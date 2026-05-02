import 'package:flutter/material.dart';

class DoctorProfileActionsSection extends StatelessWidget {
  final VoidCallback onBookNow;

  const DoctorProfileActionsSection({
    super.key,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onBookNow,
        child: const Text('احجز موعدًا مع الطبيب'),
      ),
    );
  }
}
