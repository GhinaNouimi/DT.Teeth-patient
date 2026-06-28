enum ComplaintStatus {
  open,
  inProgress,
  resolved,
}

enum ComplaintCategory {
  appointment,
  treatment,
  payment,
  other,
}

class ComplaintEntity {
  final String id;
  final String title;
  final String description;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final DateTime createdAt;
  final String? relatedReference;
  final List<String> attachments;
  final List<ComplaintUpdateEntity> updates;

  final String? centerReply;
  final DateTime? resolvedAt;

  const ComplaintEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.relatedReference,
    required this.attachments,
    required this.updates,
    this.centerReply,
    this.resolvedAt,
  });

  ComplaintEntity copyWith({
    String? id,
    String? title,
    String? description,
    ComplaintCategory? category,
    ComplaintStatus? status,
    DateTime? createdAt,
    String? relatedReference,
    List<String>? attachments,
    List<ComplaintUpdateEntity>? updates,
    String? centerReply,
    DateTime? resolvedAt,
  }) {
    return ComplaintEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      relatedReference: relatedReference ?? this.relatedReference,
      attachments: attachments ?? this.attachments,
      updates: updates ?? this.updates,
      centerReply: centerReply ?? this.centerReply,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}

class ComplaintUpdateEntity {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isFromClinic;

  const ComplaintUpdateEntity({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isFromClinic,
  });
}