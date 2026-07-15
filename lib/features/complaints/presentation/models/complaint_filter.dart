import '../../domain/entities/complaint_entity.dart';

enum ComplaintFilter {
  all,
  active,
  closed,
}

extension ComplaintFilterX on ComplaintFilter {
  bool matches(ComplaintEntity complaint) {
    switch (this) {
      case ComplaintFilter.all:
        return true;

      case ComplaintFilter.active:
        return complaint.isActive;

      case ComplaintFilter.closed:
        return complaint.isClosed;
    }
  }
}