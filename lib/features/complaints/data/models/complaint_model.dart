import '../../domain/entities/complaint_entity.dart';

class ComplaintModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String phoneNumber;
  final String? adminResponse;
  final String createdAt;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.phoneNumber,
    required this.adminResponse,
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      priority: json['priority']?.toString() ?? 'unknown',
      phoneNumber: json['phone_number']?.toString() ?? '',
      adminResponse: _parseNullableString(json['admin_response']),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'phone_number': phoneNumber,
      'admin_response': adminResponse,
      'created_at': createdAt,
    };
  }

  ComplaintEntity toEntity() {
    return ComplaintEntity(
      id: id,
      title: title,
      description: description,
      status: _mapStatus(status),
      priority: _mapPriority(priority),
      phoneNumber: phoneNumber,
      adminResponse: adminResponse,
      createdAt: _parseDateTime(createdAt),
    );
  }

  static ComplaintStatus _mapStatus(String value) {
    switch (_normalizeValue(value)) {
      case 'pending':
      case 'open':
        return ComplaintStatus.pending;

      case 'in_progress':
      case 'inprogress':
      case 'processing':
        return ComplaintStatus.inProgress;

      case 'resolved':
      case 'completed':
      case 'closed':
        return ComplaintStatus.resolved;

      case 'rejected':
      case 'declined':
        return ComplaintStatus.rejected;

      default:
        return ComplaintStatus.unknown;
    }
  }

  static ComplaintPriority _mapPriority(String value) {
    switch (_normalizeValue(value)) {
      case 'low':
        return ComplaintPriority.low;

      case 'medium':
      case 'normal':
        return ComplaintPriority.medium;

      case 'high':
      case 'urgent':
        return ComplaintPriority.high;

      default:
        return ComplaintPriority.unknown;
    }
  }

  static String _normalizeValue(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }

  static DateTime _parseDateTime(String value) {
    if (value.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.tryParse(value) ??
        DateTime.tryParse(value.replaceFirst(' ', 'T')) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final parsedValue = value.toString().trim();

    if (parsedValue.isEmpty || parsedValue.toLowerCase() == 'null') {
      return null;
    }

    return parsedValue;
  }
}