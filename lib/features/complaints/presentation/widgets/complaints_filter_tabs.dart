import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/common/app_filter_tabs.dart';
import '../models/complaint_filter.dart';

class ComplaintsFilterTabs extends StatelessWidget {
  final ComplaintFilter selectedFilter;
  final ValueChanged<ComplaintFilter> onChanged;

  const ComplaintsFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  String _label(
      BuildContext context,
      ComplaintFilter filter,
      ) {
    final l10n = context.l10n;

    switch (filter) {
      case ComplaintFilter.all:
        return l10n.allComplaints;

      case ComplaintFilter.active:
        return l10n.activeComplaints;

      case ComplaintFilter.closed:
        return l10n.closedComplaints;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFilterTabs<ComplaintFilter>(
      selectedValue: selectedFilter,
      onChanged: onChanged,
      items: ComplaintFilter.values
          .map(
            (filter) => AppFilterTabItem<ComplaintFilter>(
          value: filter,
          label: _label(context, filter),
        ),
      )
          .toList(),
    );
  }
}