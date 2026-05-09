import 'package:dt_teeth/features/appointments/presentaion/models/service_type.dart';

import '../../../doctors/presentation/data/mock_doctors_data.dart';
import '../../../doctors/presentation/models/doctor_ui_model.dart';

import 'appointment_status.dart';
import 'appointment_type.dart';
import 'appointment_ui_model.dart';

class MockAppointmentsData {
  static List<AppointmentUiModel> getAppointments() {
    final doctors = MockDoctorsData.doctors;

    return [
      AppointmentUiModel(
        id: '1',
        doctor: doctors[0],
        appointmentDate:
        DateTime.now().add(
          const Duration(days: 2),
        ),
        appointmentTime: '10:30',

        type: AppointmentType.regular,
        service: ServiceType.cleaning,
        status: AppointmentStatus.confirmed,

        patientNotes:
        'أشعر ببعض الألم في الجانب الأيسر',

        doctorNotes:
        'يرجى تنظيف الأسنان قبل الزيارة',

        emergencyDescription: null,
        requiresCall: false,

        location:
        'عيادة DT.Teeth - الطابق الثاني',

        durationMinutes: 45,

        createdAt:
        DateTime.now().subtract(
          const Duration(days: 3),
        ),
      ),

      AppointmentUiModel(
        id: '2',
        doctor: doctors[1],
        appointmentDate:
        DateTime.now().add(
          const Duration(days: 5),
        ),
        appointmentTime: '14:00',

        type: AppointmentType.followUp,
        service: ServiceType.orthodontic,
        status: AppointmentStatus.confirmed,

        patientNotes: null,

        doctorNotes:
        'متابعة تقدم التقويم',

        emergencyDescription: null,
        requiresCall: false,

        location:
        'عيادة DT.Teeth - الطابق الثاني',

        durationMinutes: 60,

        createdAt:
        DateTime.now().subtract(
          const Duration(days: 10),
        ),
      ),

      AppointmentUiModel(
        id: '3',
        doctor: doctors[0],
        appointmentDate:
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
        appointmentTime: '09:00',

        type: AppointmentType.regular,
        service: ServiceType.filling,
        status: AppointmentStatus.completed,

        patientNotes:
        'ألم بسيط في السن الأمامي',

        doctorNotes:
        'تم ملء السن بنجاح، لا توجد مضاعفات',

        emergencyDescription: null,
        requiresCall: false,

        location:
        'عيادة DT.Teeth - الطابق الثاني',

        durationMinutes: 50,

        createdAt:
        DateTime.now().subtract(
          const Duration(days: 10),
        ),
      ),

      AppointmentUiModel(
        id: '4',
        doctor: doctors[1],
        appointmentDate:
        DateTime.now().subtract(
          const Duration(days: 14),
        ),
        appointmentTime: '11:00',

        type: AppointmentType.regular,
        service: ServiceType.implant,
        status: AppointmentStatus.cancelled,

        patientNotes: null,

        doctorNotes:
        'ألغاه المريض قبل 24 ساعة',

        emergencyDescription: null,
        requiresCall: false,

        location:
        'عيادة DT.Teeth - الطابق الثاني',

        durationMinutes: 90,

        createdAt:
        DateTime.now().subtract(
          const Duration(days: 20),
        ),
      ),

      AppointmentUiModel(
        id: '5',
        doctor: doctors[2],

        appointmentDate:
        DateTime.now().add(
          const Duration(hours: 1),
        ),

        appointmentTime:
        'سيتم تحديد أقرب وقت',

        type: AppointmentType.emergency,
        service: ServiceType.emergency,

        status: AppointmentStatus.pending,

        patientNotes:
        'ألم حاد ومفاجئ',

        doctorNotes:
        'تم استلام الحالة وسيتم التواصل معك',

        emergencyDescription:
        'نزيف حاد وألم قوي في الضرس',


        requiresCall: true,

        location:
        'عيادة DT.Teeth - الطابق الثاني',

        durationMinutes: 30,

        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<AppointmentUiModel>
  getUpcomingAppointments() {
    return getAppointments()
        .where(
          (appointment) =>
      appointment.isUpcoming,
    )
        .toList();
  }

  static List<AppointmentUiModel>
  getPastAppointments() {
    return getAppointments()
        .where(
          (appointment) =>
      appointment.isPast,
    )
        .toList();
  }

  static List<AppointmentUiModel>
  getAppointmentsByStatus(
      AppointmentStatus status,
      ) {
    return getAppointments()
        .where(
          (appointment) =>
      appointment.status == status,
    )
        .toList();
  }

  static AppointmentUiModel?
  getNextAppointment() {
    final upcomingAppointments =
    getUpcomingAppointments();

    if (upcomingAppointments.isEmpty) {
      return null;
    }

    upcomingAppointments.sort(
          (a, b) => a.appointmentDate.compareTo(
        b.appointmentDate,
      ),
    );

    return upcomingAppointments.first;
  }

  static List<DoctorUiModel>
  getDoctorsByService(
      ServiceType service,
      ) {
    if (service ==
        ServiceType.emergency) {
      return MockDoctorsData.doctors
          .take(2)
          .toList();
    }

    return MockDoctorsData.doctors
        .where(
          (doctor) {
        return doctor.specialty
            .contains(
          service.relatedSpecialty,
        );
      },
    ).toList();
  }

  static List<String>
  getAvailableTimesForDoctor(
      String doctorId,
      ) {
    switch (doctorId) {
      case '1':
        return [
          '09:00',
          '09:30',
          '10:30',
          '11:30',
          '01:00',
          '02:30',
        ];

      case '2':
        return [
          '10:00',
          '11:00',
          '12:30',
          '02:00',
          '03:30',
        ];

      default:
        return [
          '09:30',
          '10:30',
          '01:30',
          '04:00',
        ];
    }
  }

  static List<int>
  getAvailableDaysForDoctor(
      String doctorId,
      ) {
    switch (doctorId) {
      case '1':
        return [
          8,
          9,
          10,
          12,
          13,
          15,
          16,
          18,
        ];

      case '2':
        return [
          7,
          8,
          11,
          12,
          14,
          17,
          19,
        ];

      default:
        return [
          8,
          10,
          11,
          13,
          15,
          18,
        ];
    }
  }
}