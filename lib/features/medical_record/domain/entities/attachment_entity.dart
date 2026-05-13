enum AttachmentCategory {
  images,
  xray,
  reports,
}

enum AttachmentType {
  image,
  pdf,
}

class AttachmentEntity {
  final String id;
  final String treatmentId;
  final String title;
  final String dateLabel;
  final AttachmentCategory category;
  final AttachmentType type;
  final String previewLabel;

  const AttachmentEntity({
    required this.id,
    required this.treatmentId,
    required this.title,
    required this.dateLabel,
    required this.category,
    required this.type,
    required this.previewLabel,
  });
}
