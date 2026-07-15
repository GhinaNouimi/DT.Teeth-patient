import '../../models/complaint_filter.dart';

sealed class ComplaintsEvent {
  const ComplaintsEvent();
}

final class LoadComplaintsRequested extends ComplaintsEvent {
  final String languageCode;

  const LoadComplaintsRequested({
    required this.languageCode,
  });
}

final class RefreshComplaintsRequested extends ComplaintsEvent {
  final String languageCode;

  const RefreshComplaintsRequested({
    required this.languageCode,
  });
}

final class ComplaintFilterChanged extends ComplaintsEvent {
  final ComplaintFilter filter;

  const ComplaintFilterChanged({
    required this.filter,
  });
}