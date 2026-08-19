import 'package:dt_teeth/features/appointments/data/datasources/local/appointments_local_data_source.dart';
import 'package:dt_teeth/features/appointments/data/datasources/remote/appointments_remote_data_source.dart';
import 'package:dt_teeth/features/appointments/data/models/add_appointment_request_model.dart';
import 'package:dt_teeth/features/appointments/data/models/appointment_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointments_response_model.dart';
import 'package:dt_teeth/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentsRemoteDataSource extends Mock
    implements AppointmentsRemoteDataSource {}

class MockAppointmentsLocalDataSource extends Mock
    implements AppointmentsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      AddAppointmentRequestModel(
        dentistId: 0,
        appointmentTypeId: 0,
        appointmentTime: DateTime(2000),
        type: AppointmentBookingType.unknown,
      ),
    );
  });

  testWidgets(
    'IT-OFFLINE-01 cached reads work and appointment writes are blocked',
    (tester) async {
      final remoteDataSource = MockAppointmentsRemoteDataSource();
      final localDataSource = MockAppointmentsLocalDataSource();
      final networkInfo = MockNetworkInfo();
      final repository = AppointmentsRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo,
      );

      final cachedAppointment = AppointmentModel(
        id: 23,
        dentistId: 4,
        dentistName: 'Dr. Lina',
        appointmentTypeName: 'كشف عام',
        appointmentTypeNameEn: 'General Checkup',
        type: AppointmentBookingType.newTreatment,
        status: AppointmentStatus.pending,
        appointmentTime: DateTime(2026, 8, 26, 10),
      );
      final cachedResponse = ShowAppointmentsResponseModel(
        success: true,
        count: 1,
        appointments: <AppointmentModel>[cachedAppointment],
      );

      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => localDataSource.getCachedUpcomingAppointments(),
      ).thenAnswer((_) async => cachedResponse);

      final cachedResult = await repository.showAppointments(
        languageCode: 'en',
      );

      Object? blockedWriteError;
      try {
        await repository.addAppointment(
          dentistId: 4,
          appointmentTypeId: 1,
          appointmentTime: DateTime(2026, 8, 26, 10),
          type: AppointmentBookingType.newTreatment,
          languageCode: 'en',
        );
      } catch (error) {
        blockedWriteError = error;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                Text('cache-${cachedResult.isFromCache}'),
                Text('appointments-${cachedResult.data.length}'),
                Text('dentist-${cachedResult.data.single.dentistName}'),
                Text('write-blocked-${blockedWriteError != null}'),
              ],
            ),
          ),
        ),
      );

      expect(cachedResult.isFromCache, isTrue);
      expect(cachedResult.data.single.id, 23);
      expect(find.text('cache-true'), findsOneWidget);
      expect(find.text('appointments-1'), findsOneWidget);
      expect(find.text('dentist-Dr. Lina'), findsOneWidget);
      expect(find.text('write-blocked-true'), findsOneWidget);
      expect(
        blockedWriteError.toString(),
        contains('cannot be completed without an internet connection'),
      );

      verify(() => localDataSource.getCachedUpcomingAppointments()).called(1);
      verifyNever(() => remoteDataSource.showAppointments());
      verifyNever(() => remoteDataSource.addAppointment(any()));
      expect(tester.takeException(), isNull);
    },
  );
}
