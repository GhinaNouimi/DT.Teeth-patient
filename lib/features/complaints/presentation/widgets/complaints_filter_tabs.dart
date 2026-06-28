import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppFilterTabs<ComplaintFilter>(
      selectedValue: selectedFilter,
      onChanged: onChanged,
      items: ComplaintFilter.values
          .map(
            (filter) => AppFilterTabItem<ComplaintFilter>(
          value: filter,
          label: filter.label,
        ),
      )
          .toList(),
    );
  }
}