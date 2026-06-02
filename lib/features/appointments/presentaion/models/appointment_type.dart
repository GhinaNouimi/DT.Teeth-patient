enum AppointmentType {
  emergency('طارئ', 'emergency'),
  regular('عادي', 'regular'),
  followUp('متابعة', 'follow_up');

  final String displayName;
  final String value;

  const AppointmentType(this.displayName, this.value);

  bool get isEmergency => this == AppointmentType.emergency;

  static AppointmentType fromValue(String value) {
    return AppointmentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AppointmentType.regular,
    );
  }
}
