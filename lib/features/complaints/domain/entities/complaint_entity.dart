enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
  rejected,
  unknown,
}

enum ComplaintPriority {
  low,
  medium,
  high,
  unknown,
}

class ComplaintEntity {
  final int id;
  final String title;
  final String description;
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final String phoneNumber;
  final String? adminResponse;
  final DateTime createdAt;

  const ComplaintEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.phoneNumber,
    required this.adminResponse,
    required this.createdAt,
  });

  bool get hasAdminResponse =>
      adminResponse != null && adminResponse!.trim().isNotEmpty;

  bool get isActive =>
      status == ComplaintStatus.pending ||
          status == ComplaintStatus.inProgress;

  bool get isClosed =>
      status == ComplaintStatus.resolved ||
          status == ComplaintStatus.rejected;

  ComplaintEntity copyWith({
    int? id,
    String? title,
    String? description,
    ComplaintStatus? status,
    ComplaintPriority? priority,
    String? phoneNumber,
    String? adminResponse,
    bool clearAdminResponse = false,
    DateTime? createdAt,
  }) {
    return ComplaintEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      adminResponse:
      clearAdminResponse ? null : adminResponse ?? this.adminResponse,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}