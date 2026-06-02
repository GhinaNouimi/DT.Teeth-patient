enum AppointmentStatus {
  confirmed('مؤكد', 'confirmed'),
  pending('قيد الانتظار', 'pending'),
  cancelled('ملغي', 'cancelled'),
  completed('مكتمل', 'completed');

  final String displayName;
  final String value;

  const AppointmentStatus(this.displayName, this.value);

  static AppointmentStatus fromValue(String value) {
    return AppointmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AppointmentStatus.pending,
    );
  }
}
