import 'package:dio/dio.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/features/appointments/data/datasources/local/appointments_local_data_source.dart';
import 'package:dt_teeth/features/appointments/data/datasources/remote/appointments_remote_data_source.dart';
import 'package:dt_teeth/features/appointments/data/models/add_appointment_request_model.dart';
import 'package:dt_teeth/features/appointments/data/models/appointment_action_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/appointment_model.dart';
import 'package:dt_teeth/features/appointments/data/models/cancel_appointment_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointment_details_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/show_appointments_response_model.dart';
import 'package:dt_teeth/features/appointments/data/models/update_appointment_request_model.dart';
import 'package:dt_teeth/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:dt_teeth/features/appointments/domain/entities/appointment_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentsRemoteDataSource extends Mock
    implements AppointmentsRemoteDataSource {}

class MockAppointmentsLocalDataSource extends Mock
    implements AppointmentsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

AppointmentModel appointmentModel({
  int id = 23,
  AppointmentStatus status = AppointmentStatus.pending,
}) {
  return AppointmentModel(
    id: id,
    dentistId: 4,
    dentistName: 'Dr. Lina',
    appointmentTypeName: 'كشف عام',
    appointmentTypeNameEn: 'General Checkup',
    type: AppointmentBookingType.newTreatment,
    status: status,
    appointmentTime: DateTime(2026, 8, 26, 10),
  );
}

ShowAppointmentsResponseModel appointmentsResponse({
  List<AppointmentModel>? appointments,
}) {
  final items = appointments ?? <AppointmentModel>[appointmentModel()];
  return ShowAppointmentsResponseModel(
    success: true,
    count: items.length,
    appointments: items,
  );
}

void main() {
  late MockAppointmentsRemoteDataSource remoteDataSource;
  late MockAppointmentsLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;
  late AppointmentsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      AddAppointmentRequestModel(
        dentistId: 0,
        appointmentTypeId: 0,
        appointmentTime: DateTime(2000),
        type: AppointmentBookingType.unknown,
      ),
    );
    registerFallbackValue(
      UpdateAppointmentRequestModel(appointmentTime: DateTime(2000)),
    );
  });

  setUp(() {
    remoteDataSource = MockAppointmentsRemoteDataSource();
    localDataSource = MockAppointmentsLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = AppointmentsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('showAppointments', () {
    test(
      'UT-REP-APP-01 online: returns remote data and updates cache',
      () async {
        final response = appointmentsResponse();
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.showAppointments(),
        ).thenAnswer((_) async => response);
        when(
          () => localDataSource.cacheUpcomingAppointments(response),
        ).thenAnswer((_) async {});

        final result = await repository.showAppointments(languageCode: 'en');

        expect(result.data, same(response.appointments));
        expect(result.isFromCache, isFalse);
        verify(() => remoteDataSource.showAppointments()).called(1);
        verify(
          () => localDataSource.cacheUpcomingAppointments(response),
        ).called(1);
        verifyNever(() => localDataSource.getCachedUpcomingAppointments());
      },
    );

    test(
      'UT-REP-APP-02 offline with cache: returns cached data without remote call',
      () async {
        final cachedResponse = appointmentsResponse();
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => localDataSource.getCachedUpcomingAppointments(),
        ).thenAnswer((_) async => cachedResponse);

        final result = await repository.showAppointments(languageCode: 'ar');

        expect(result.data, same(cachedResponse.appointments));
        expect(result.isFromCache, isTrue);
        verify(() => localDataSource.getCachedUpcomingAppointments()).called(1);
        verifyNever(() => remoteDataSource.showAppointments());
      },
    );

    test(
      'UT-REP-APP-03 offline without cache: returns localized no-cache error',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => localDataSource.getCachedUpcomingAppointments(),
        ).thenThrow(Exception('cache missing'));

        await expectLater(
          repository.showAppointments(languageCode: 'en'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'message',
              contains('No saved data is available to show offline.'),
            ),
          ),
        );
        verifyNever(() => remoteDataSource.showAppointments());
      },
    );

    test(
      'UT-REP-APP-04 online connection failure: maps Dio error to user message',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => remoteDataSource.showAppointments()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/patient/showAppointments'),
            type: DioExceptionType.connectionError,
          ),
        );

        await expectLater(
          repository.showAppointments(languageCode: 'en'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'message',
              contains('Could not connect to the server.'),
            ),
          ),
        );
        verify(() => remoteDataSource.showAppointments()).called(1);
      },
    );
  });

  test(
    'UT-REP-APP-05 details online: caches and returns the requested appointment',
    () async {
      final response = ShowAppointmentDetailsResponseModel(
        success: true,
        appointment: appointmentModel(id: 42),
      );
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.showAppointmentDetails(42),
      ).thenAnswer((_) async => response);
      when(
        () => localDataSource.cacheAppointmentDetails(42, response),
      ).thenAnswer((_) async {});

      final result = await repository.showAppointmentDetails(
        appointmentId: 42,
        languageCode: 'ar',
      );

      expect(result.data.id, 42);
      expect(result.isFromCache, isFalse);
      verify(() => remoteDataSource.showAppointmentDetails(42)).called(1);
      verify(
        () => localDataSource.cacheAppointmentDetails(42, response),
      ).called(1);
    },
  );

  group('offline write protection', () {
    test(
      'UT-REP-APP-06 blocks addAppointment before creating remote request',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);

        await expectLater(
          repository.addAppointment(
            dentistId: 4,
            appointmentTypeId: 1,
            appointmentTime: DateTime(2026, 8, 26, 10),
            type: AppointmentBookingType.newTreatment,
            languageCode: 'en',
          ),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'message',
              contains('cannot be completed without an internet connection'),
            ),
          ),
        );
        verifyNever(() => remoteDataSource.addAppointment(any()));
      },
    );

    test('UT-REP-APP-07 blocks updateAppointment before remote call', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      await expectLater(
        repository.updateAppointment(
          appointmentId: 23,
          appointmentTime: DateTime(2026, 8, 27, 11),
          languageCode: 'ar',
        ),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('لا يمكن تنفيذ هذه العملية بدون اتصال بالإنترنت'),
          ),
        ),
      );
      verifyNever(() => remoteDataSource.updateAppointment(any(), any()));
    });

    test('UT-REP-APP-08 blocks cancelAppointment before remote call', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      await expectLater(
        repository.cancelAppointment(appointmentId: 23, languageCode: 'en'),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('cannot be completed without an internet connection'),
          ),
        ),
      );
      verifyNever(() => remoteDataSource.cancelAppointment(any()));
    });
  });

  test(
    'UT-REP-APP-09 successful booking keeps success even when cache refresh fails',
    () async {
      final time = DateTime(2026, 8, 26, 10);
      final actionResponse = AppointmentActionResponseModel(
        success: true,
        message: 'Booking request sent',
        appointment: appointmentModel(),
      );
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.addAppointment(any()),
      ).thenAnswer((_) async => actionResponse);
      when(
        () => remoteDataSource.showAppointments(),
      ).thenThrow(Exception('refresh unavailable'));
      when(
        () => remoteDataSource.showPreviousAppointments(),
      ).thenThrow(Exception('refresh unavailable'));
      when(
        () => remoteDataSource.showAppointmentDetails(23),
      ).thenThrow(Exception('details unavailable'));
      when(
        () => remoteDataSource.showDentistSchedule(4),
      ).thenThrow(Exception('schedule unavailable'));

      final result = await repository.addAppointment(
        dentistId: 4,
        appointmentTypeId: 1,
        appointmentTime: time,
        type: AppointmentBookingType.newTreatment,
        treatmentId: 9,
        notes: ' Morning appointment ',
        languageCode: 'en',
      );

      final captured =
          verify(
                () => remoteDataSource.addAppointment(captureAny()),
              ).captured.single
              as AddAppointmentRequestModel;
      expect(captured.toJson(), <String, dynamic>{
        'dentist_id': 4,
        'appointment_type_id': 1,
        'appointment_time': '2026-08-26 10:00:00',
        'type': 'new_treatment',
        'treatment_id': 9,
        'notes': 'Morning appointment',
      });
      expect(result.message, 'Booking request sent');
      expect(result.appointment, same(actionResponse.appointment));
    },
  );

  test(
    'UT-REP-APP-10 successful cancellation stays successful if cache refresh fails',
    () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.cancelAppointment(23)).thenAnswer(
        (_) async => const CancelAppointmentResponseModel(
          success: true,
          message: 'Appointment cancelled',
        ),
      );
      when(
        () => remoteDataSource.showAppointments(),
      ).thenThrow(Exception('refresh unavailable'));

      final result = await repository.cancelAppointment(
        appointmentId: 23,
        languageCode: 'en',
      );

      expect(result, 'Appointment cancelled');
      verify(() => remoteDataSource.cancelAppointment(23)).called(1);
    },
  );
}
