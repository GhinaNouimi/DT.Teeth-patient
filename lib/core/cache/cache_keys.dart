class CacheKeys {
  const CacheKeys._();

  static const profile = 'cached_profile';

  static const doctors = 'cached_doctors';
  static const doctorsBySpecialtyPrefix = 'cached_doctors_by_specialty_';

  static const upcomingAppointments = 'cached_upcoming_appointments';
  static const pastAppointments = 'cached_past_appointments';
  static const appointmentDetailsPrefix = 'cached_appointment_details_';
  static const prescriptions = 'cached_prescriptions';
  static const prescriptionDetailsPrefix = 'cached_prescription_details_';
}