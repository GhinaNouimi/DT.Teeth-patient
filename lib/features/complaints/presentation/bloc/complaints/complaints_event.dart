import '../../models/complaint_filter.dart';

abstract class ComplaintsEvent {
  const ComplaintsEvent();
}

class LoadComplaintsRequested extends ComplaintsEvent {
  const LoadComplaintsRequested();
}

class ComplaintFilterChanged extends ComplaintsEvent {
  final ComplaintFilter filter;

  const ComplaintFilterChanged(this.filter);
}

class RefreshComplaintsRequested extends ComplaintsEvent {
  const RefreshComplaintsRequested();
}