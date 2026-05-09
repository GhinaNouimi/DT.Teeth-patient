enum ServiceType {
  emergency('خدمة إسعافية', 'emergency'),
  cleaning('تنظيف روتيني', 'cleaning'),
  whitening('تبييض الأسنان', 'whitening'),
  filling('الحشوات', 'filling'),
  extraction('خلع الأسنان', 'extraction'),
  orthodontic('تقويم الأسنان', 'orthodontic'),
  implant('زراعة الأسنان', 'implant'),
  pediatric('طب أسنان الأطفال', 'pediatric');

  final String displayName;
  final String value;

  const ServiceType(
      this.displayName,
      this.value,
      );

  static ServiceType fromValue(String value) {
    return ServiceType.values.firstWhere(
          (service) => service.value == value,
      orElse: () => ServiceType.cleaning,
    );
  }

  String get relatedSpecialty {
    switch (this) {
      case ServiceType.emergency:
        return 'طوارئ';

      case ServiceType.cleaning:
        return 'تنظيف';

      case ServiceType.whitening:
        return 'تجميل';

      case ServiceType.filling:
      case ServiceType.extraction:
        return 'علاج';

      case ServiceType.orthodontic:
        return 'تقويم الأسنان';

      case ServiceType.implant:
        return 'زراعة الأسنان';

      case ServiceType.pediatric:
        return 'طب أسنان الأطفال';
    }
  }
}