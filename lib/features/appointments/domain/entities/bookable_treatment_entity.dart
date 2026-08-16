class BookableTreatmentEntity {
  final int id;

  final String treatmentTypeName;
  final String treatmentTypeNameEn;

  final int dentistId;
  final String dentistName;

  final int totalSessionsNeeded;
  final int sessionsCompleted;

  const BookableTreatmentEntity({
    required this.id,
    required this.treatmentTypeName,
    required this.treatmentTypeNameEn,
    required this.dentistId,
    required this.dentistName,
    required this.totalSessionsNeeded,
    required this.sessionsCompleted,
  });

  String localizedTreatmentType(
      String languageCode,
      ) {
    final isArabic =
    languageCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      return treatmentTypeName.isNotEmpty
          ? treatmentTypeName
          : treatmentTypeNameEn;
    }

    return treatmentTypeNameEn.isNotEmpty
        ? treatmentTypeNameEn
        : treatmentTypeName;
  }

  double get progress {
    if (totalSessionsNeeded <= 0) {
      return 0;
    }

    return (sessionsCompleted / totalSessionsNeeded)
        .clamp(0.0, 1.0);
  }

  int get remainingSessions {
    final remaining =
        totalSessionsNeeded - sessionsCompleted;

    return remaining < 0 ? 0 : remaining;
  }
}