import 'package:dt_teeth/core/localization/app_localizations.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/features/appointments/presentaion/widgets/appointment_card_widget.dart';
import 'package:dt_teeth/features/doctors/domain/entities/dentist_entity.dart';
import 'package:dt_teeth/features/doctors/presentation/widgets/doctor_card_widget.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/medication_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/prescription/prescription_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_dentist_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_session_entity.dart';
import 'package:dt_teeth/features/medical_record/domain/entities/treatment/treatment_type_entity.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/prescription/prescription_card.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/treatment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget localizedHost(Widget child, {String language = 'en'}) => MaterialApp(
  locale: Locale(language),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

const dentist = DentistEntity(
  id: 4,
  userId: 10,
  name: 'Dr. Lina',
  email: 'lina@test.com',
  phone: '0999',
  role: 2,
  specializationName: 'طب أسنان الأطفال',
  specializationNameEn: 'Pediatric Dentistry',
);

const prescription = PrescriptionEntity(
  id: 7,
  dentistName: 'Dr. Lina',
  notes: 'Take after food',
  createdAt: '2026-07-04',
  medications: <MedicationEntity>[
    MedicationEntity(
      name: 'Amoxicillin',
      dosage: '500mg',
      frequency: '3/day',
      duration: '7 days',
    ),
  ],
);

TreatmentEntity treatment({
  String status = 'ongoing',
  String? notes = 'Continue',
}) => TreatmentEntity(
  id: 8,
  treatmentType: const TreatmentTypeEntity(
    id: 2,
    name: 'تقويم الأسنان',
    nameEn: 'Orthodontics',
  ),
  dentist: const TreatmentDentistEntity(id: 4, name: 'Dr. Lina'),
  status: status,
  totalSessionsNeeded: 10,
  sessionsCompleted: 4,
  notes: notes,
  createdAt: '2026-07-04',
  sessions: const <TreatmentSessionEntity>[],
);

AppointmentEntity appointment({
  AppointmentStatus status = AppointmentStatus.pending,
  AppointmentBookingType type = AppointmentBookingType.newTreatment,
}) => AppointmentEntity(
  id: 23,
  dentistId: 4,
  dentistName: 'Dr. Lina',
  appointmentTypeName: 'كشف عام',
  appointmentTypeNameEn: 'General Checkup',
  type: type,
  status: status,
  appointmentTime: DateTime(2026, 8, 26, 10),
);

void main() {
  group('DoctorCardWidget', () {
    testWidgets(
      'WT-FEAT-01 renders English specialization and fallback avatar',
      (tester) async {
        await tester.pumpWidget(
          localizedHost(
            DoctorCardWidget(
              dentist: dentist,
              languageCode: 'en',
              onTap: () {},
            ),
          ),
        );
        expect(find.text('Dr. Lina'), findsOneWidget);
        expect(find.text('Pediatric Dentistry'), findsOneWidget);
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      },
    );

    testWidgets('WT-FEAT-02 renders Arabic specialization', (tester) async {
      await tester.pumpWidget(
        localizedHost(
          DoctorCardWidget(dentist: dentist, languageCode: 'ar', onTap: () {}),
          language: 'ar',
        ),
      );
      expect(find.text('طب أسنان الأطفال'), findsOneWidget);
    });

    testWidgets('WT-FEAT-03 tap invokes doctor selection', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        localizedHost(
          DoctorCardWidget(
            dentist: dentist,
            languageCode: 'en',
            onTap: () => taps++,
          ),
        ),
      );
      await tester.tap(find.text('Dr. Lina'));
      expect(taps, 1);
    });
  });

  group('PrescriptionCard', () {
    testWidgets(
      'WT-FEAT-04 shows first medication, dentist, date, count and notes',
      (tester) async {
        await tester.pumpWidget(
          localizedHost(
            PrescriptionCard(prescription: prescription, onTap: () {}),
          ),
        );
        expect(find.text('Amoxicillin'), findsOneWidget);
        expect(find.text('Dr. Lina'), findsOneWidget);
        expect(find.textContaining('2026-07-04'), findsOneWidget);
        expect(find.textContaining('1 '), findsOneWidget);
        expect(find.text('Take after food'), findsOneWidget);
      },
    );

    testWidgets('WT-FEAT-05 hides empty notes safely', (tester) async {
      const emptyNotes = PrescriptionEntity(
        id: 8,
        dentistName: 'Doctor',
        notes: '   ',
        createdAt: 'date',
        medications: <MedicationEntity>[],
      );
      await tester.pumpWidget(
        localizedHost(PrescriptionCard(prescription: emptyNotes, onTap: () {})),
      );
      expect(find.text('   '), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('WT-FEAT-06 tapping prescription invokes action', (
      tester,
    ) async {
      var opened = false;
      await tester.pumpWidget(
        localizedHost(
          PrescriptionCard(
            prescription: prescription,
            onTap: () => opened = true,
          ),
        ),
      );
      await tester.tap(find.text('Amoxicillin'));
      expect(opened, isTrue);
    });
  });

  group('TreatmentCard', () {
    testWidgets('WT-FEAT-07 localizes treatment name to English', (
      tester,
    ) async {
      await tester.pumpWidget(
        localizedHost(TreatmentCard(treatment: treatment(), onTap: () {})),
      );
      expect(find.text('Orthodontics'), findsOneWidget);
      expect(find.text('Dr. Lina'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('WT-FEAT-08 localizes treatment name to Arabic and uses RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        localizedHost(
          TreatmentCard(treatment: treatment(), onTap: () {}),
          language: 'ar',
        ),
      );
      expect(find.text('تقويم الأسنان'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(TreatmentCard))),
        TextDirection.rtl,
      );
    });

    testWidgets('WT-FEAT-09 zero required sessions displays zero percent', (
      tester,
    ) async {
      final zero = TreatmentEntity(
        id: 9,
        treatmentType: treatment().treatmentType,
        dentist: treatment().dentist,
        status: 'ongoing',
        totalSessionsNeeded: 0,
        sessionsCompleted: 4,
        createdAt: 'date',
        sessions: const <TreatmentSessionEntity>[],
      );
      await tester.pumpWidget(
        localizedHost(TreatmentCard(treatment: zero, onTap: () {})),
      );
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('WT-FEAT-10 details button invokes treatment action', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        localizedHost(
          TreatmentCard(treatment: treatment(notes: null), onTap: () => taps++),
        ),
      );

      final detailsAction = find.byIcon(Icons.arrow_back_ios_new_rounded);

      expect(detailsAction, findsOneWidget);

      await tester.tap(detailsAction);
      await tester.pump();

      expect(taps, 1);
    });
  });

  group('AppointmentCardWidget', () {
    testWidgets('WT-FEAT-11 shows dentist, localized type, date and time', (
      tester,
    ) async {
      await tester.pumpWidget(
        localizedHost(
          AppointmentCardWidget(appointment: appointment(), onTap: () {}),
        ),
      );
      expect(find.text('Dr. Lina'), findsOneWidget);
      expect(find.text('General Checkup'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
    });

    testWidgets(
      'WT-FEAT-12 emergency uses emergency icon and extra status chip',
      (tester) async {
        await tester.pumpWidget(
          localizedHost(
            AppointmentCardWidget(
              appointment: appointment(type: AppointmentBookingType.emergency),
              onTap: () {},
            ),
          ),
        );
        expect(find.byIcon(Icons.emergency_rounded), findsOneWidget);
        expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
      },
    );

    testWidgets('WT-FEAT-13 cancelling card is dimmed and blocks tap', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        localizedHost(
          AppointmentCardWidget(
            appointment: appointment(),
            onTap: () => taps++,
            isCancelling: true,
          ),
        ),
      );
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0.65,
      );
      await tester.tap(find.text('Dr. Lina'));
      expect(taps, 0);
      expect(find.byIcon(Icons.hourglass_top_rounded), findsOneWidget);
    });

    testWidgets('WT-FEAT-14 normal card tap invokes callback', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        localizedHost(
          AppointmentCardWidget(
            appointment: appointment(status: AppointmentStatus.approved),
            onTap: () => taps++,
          ),
        ),
      );
      await tester.tap(find.text('Dr. Lina'));
      expect(taps, 1);
    });
  });
}
