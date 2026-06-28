import '../../domain/entities/complaint_entity.dart';

class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime createdAt;
  final String? relatedReference;
  final List<String> attachments;
  final List<ComplaintUpdateModel> updates;
  final String? centerReply;
  final DateTime? resolvedAt;

  const ComplaintModel({
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

  ComplaintEntity toEntity() {
    return ComplaintEntity(
      id: id,
      title: title,
      description: description,
      category: _mapCategory(category),
      status: _mapStatus(status),
      createdAt: createdAt,
      relatedReference: relatedReference,
      attachments: attachments,
      updates: updates.map((e) => e.toEntity()).toList(),
      centerReply: centerReply,
      resolvedAt: resolvedAt,
    );
  }

  factory ComplaintModel.fromEntity(ComplaintEntity entity) {
    return ComplaintModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category.name,
      status: entity.status.name,
      createdAt: entity.createdAt,
      relatedReference: entity.relatedReference,
      attachments: entity.attachments,
      updates: entity.updates.map(ComplaintUpdateModel.fromEntity).toList(),
      centerReply: entity.centerReply,
      resolvedAt: entity.resolvedAt,
    );
  }

  static ComplaintCategory _mapCategory(String value) {
    switch (value) {
      case 'appointment':
        return ComplaintCategory.appointment;
      case 'treatment':
        return ComplaintCategory.treatment;
      case 'payment':
        return ComplaintCategory.payment;
      default:
        return ComplaintCategory.other;
    }
  }

  static ComplaintStatus _mapStatus(String value) {
    switch (value) {
      case 'inProgress':
        return ComplaintStatus.inProgress;
      case 'resolved':
        return ComplaintStatus.resolved;
      default:
        return ComplaintStatus.open;
    }
  }
}

class ComplaintUpdateModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isFromClinic;

  const ComplaintUpdateModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isFromClinic,
  });

  ComplaintUpdateEntity toEntity() {
    return ComplaintUpdateEntity(
      id: id,
      message: message,
      createdAt: createdAt,
      isFromClinic: isFromClinic,
    );
  }

  factory ComplaintUpdateModel.fromEntity(ComplaintUpdateEntity entity) {
    return ComplaintUpdateModel(
      id: entity.id,
      message: entity.message,
      createdAt: entity.createdAt,
      isFromClinic: entity.isFromClinic,
    );
  }
}