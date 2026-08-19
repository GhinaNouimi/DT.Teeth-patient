import 'package:dio/dio.dart';
import 'package:dt_teeth/core/network/api_constants.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/remote/prescription_remote_data_source_impl.dart';
import 'package:dt_teeth/features/medical_record/data/datasources/remote/treatment_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> response(dynamic data) => Response<dynamic>(
  requestOptions: RequestOptions(path: '/test'),
  data: data,
  statusCode: 200,
);

Map<String, dynamic> prescriptionJson() => <String, dynamic>{
  'id': 7,
  'dentist_name': 'Dr. Lina',
  'created_at': '2026-07-04',
  'medications': <dynamic>[],
};

Map<String, dynamic> treatmentJson() => <String, dynamic>{
  'id': 8,
  'treatment_type': <String, dynamic>{
    'id': 2,
    'name': 'تقويم',
    'name_en': 'Orthodontics',
  },
  'dentist': <String, dynamic>{'id': 4, 'name': 'Dr. Lina'},
  'status': 'ongoing',
  'total_sessions_needed': 10,
  'sessions_completed': 4,
  'created_at': '2026-07-04',
  'sessions': <dynamic>[],
};

void main() {
  late MockDio dio;
  setUp(() => dio = MockDio());

  test(
    'UT-MR-REMOTE-01 prescription list calls correct endpoint and parses data',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllPrescriptions),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'data': <dynamic>[prescriptionJson()],
        }),
      );
      final result = await PrescriptionRemoteDataSourceImpl(
        dio: dio,
      ).getAllPrescriptions();
      expect(result.single.id, 7);
      verify(
        () => dio.get<dynamic>(ApiConstants.patientShowAllPrescriptions),
      ).called(1);
    },
  );

  test(
    'UT-MR-REMOTE-02 prescription list filters malformed API elements',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllPrescriptions),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'data': <dynamic>[prescriptionJson(), 'bad', 2],
        }),
      );
      final result = await PrescriptionRemoteDataSourceImpl(
        dio: dio,
      ).getAllPrescriptions();
      expect(result, hasLength(1));
    },
  );

  test(
    'UT-MR-REMOTE-03 prescription details passes selected id in path',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowPrescriptionDetails(7)),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{'data': prescriptionJson()}),
      );
      final result = await PrescriptionRemoteDataSourceImpl(
        dio: dio,
      ).getPrescriptionDetails(7);
      expect(result.dentistName, 'Dr. Lina');
      verify(
        () => dio.get<dynamic>('/patient/showPrescriptionDetails/7'),
      ).called(1);
    },
  );

  test(
    'UT-MR-REMOTE-04 missing prescription list data becomes empty list',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllPrescriptions),
      ).thenAnswer((_) async => response(<String, dynamic>{}));
      expect(
        await PrescriptionRemoteDataSourceImpl(dio: dio).getAllPrescriptions(),
        isEmpty,
      );
    },
  );

  test(
    'UT-MR-REMOTE-05 treatment list calls correct endpoint and parses data',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllTreatments),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'data': <dynamic>[treatmentJson()],
        }),
      );
      final result = await TreatmentRemoteDataSourceImpl(
        dio: dio,
      ).getAllTreatments();
      expect(result.single.id, 8);
      verify(
        () => dio.get<dynamic>(ApiConstants.patientShowAllTreatments),
      ).called(1);
    },
  );

  test(
    'UT-MR-REMOTE-06 treatment list filters malformed API elements',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllTreatments),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{
          'data': <dynamic>[treatmentJson(), false, 'bad'],
        }),
      );
      expect(
        await TreatmentRemoteDataSourceImpl(dio: dio).getAllTreatments(),
        hasLength(1),
      );
    },
  );

  test(
    'UT-MR-REMOTE-07 treatment details passes id and parses nested result',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowTreatmentDetails(8)),
      ).thenAnswer(
        (_) async => response(<String, dynamic>{'data': treatmentJson()}),
      );
      final result = await TreatmentRemoteDataSourceImpl(
        dio: dio,
      ).getTreatmentDetails(8);
      expect(result.treatmentType.nameEn, 'Orthodontics');
      verify(
        () => dio.get<dynamic>('/patient/showTreatmentdetails/8'),
      ).called(1);
    },
  );

  test(
    'UT-MR-REMOTE-08 missing treatment list data becomes empty list',
    () async {
      when(
        () => dio.get<dynamic>(ApiConstants.patientShowAllTreatments),
      ).thenAnswer((_) async => response(<String, dynamic>{}));
      expect(
        await TreatmentRemoteDataSourceImpl(dio: dio).getAllTreatments(),
        isEmpty,
      );
    },
  );
}
