import '../../domain/entities/complaint_entity.dart';

enum ComplaintFilter {
  all,
  received,
  inProgress,
  resolved,
}

extension ComplaintFilterX on ComplaintFilter {
  String get label {
    switch (this) {
      case ComplaintFilter.all:
        return 'الكل';
      case ComplaintFilter.received:
        return 'تم الاستلام';
      case ComplaintFilter.inProgress:
        return 'قيد المعالجة';
      case ComplaintFilter.resolved:
        return 'تم الحل';
    }
  }

  ComplaintStatus? get status {
    switch (this) {
      case ComplaintFilter.all:
        return null;
      case ComplaintFilter.received:
        return ComplaintStatus.open;
      case ComplaintFilter.inProgress:
        return ComplaintStatus.inProgress;
      case ComplaintFilter.resolved:
        return ComplaintStatus.resolved;
    }
  }
}