import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/complaint_entity.dart';
import '../widgets/complaint_details_card.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: AppTopBar(
                title: l10n.complaintDetails,
                showBackButton: true,
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  28,
                ),
                children: [
                  ComplaintDetailsCard(
                    complaint: complaint,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}