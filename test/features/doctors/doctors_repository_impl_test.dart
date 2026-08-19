import 'package:dt_teeth/core/network/network_error_messages.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/features/doctors/data/datasources/local/doctors_local_data_source.dart';
import 'package:dt_teeth/features/doctors/data/datasources/remote/doctors_remote_data_source.dart';
import 'package:dt_teeth/features/doctors/data/models/add_dentist_rate_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/dentist_details_model.dart';
import 'package:dt_teeth/features/doctors/data/models/dentist_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_all_dentists_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentist_details_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentist_rate_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentists_by_specialization_response_model.dart';
import 'package:dt_teeth/features/doctors/data/repositories/doctors_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements DoctorsRemoteDataSource {}

class MockLocal extends Mock implements DoctorsLocalDataSource {}

class MockNetwork extends Mock implements NetworkInfo {}

const dentist = DentistModel(
  id: 4,
  userId: 10,
  name: 'Dr. Lina',
  email: 'lina@test.com',
  phone: '0999',
  role: 2,
  specializationName: 'طب أطفال',
  specializationNameEn: 'Pediatric',
);
const details = DentistDetailsModel(
  id: 4,
  name: 'Dr. Lina',
  profilePicture: null,
  specializationAr: 'طب أطفال',
  specializationEn: 'Pediatric',
  yearsOfExperience: 7,
  averageRating: '3.8',
  bio: 'Bio',
);
const allResponse = ShowAllDentistsResponseModel(
  success: true,
  data: <DentistModel>[dentist],
);
const detailsResponse = ShowDentistDetailsResponseModel(
  success: true,
  data: details,
);
const specialtyResponse = ShowDentistsBySpecializationResponseModel(
  success: true,
  count: 1,
  data: <DentistDetailsModel>[details],
);

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockNetwork network;
  late DoctorsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(allResponse);
    registerFallbackValue(detailsResponse);
    registerFallbackValue(specialtyResponse);
  });
  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    network = MockNetwork();
    repository = DoctorsRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
      networkInfo: network,
    );
  });

  test('UT-REP-DOC-01 online list returns API data and caches it', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.showAllDentists()).thenAnswer((_) async => allResponse);
    when(() => local.cacheDentists(allResponse)).thenAnswer((_) async {});
    final result = await repository.showAllDentists(languageCode: 'ar');
    expect(result.data.single.id, 4);
    expect(result.isFromCache, isFalse);
    verify(() => local.cacheDentists(allResponse)).called(1);
  });

  test(
    'UT-REP-DOC-02 offline list returns cache without calling API',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(
        () => local.getCachedDentists(),
      ).thenAnswer((_) async => allResponse);
      final result = await repository.showAllDentists(languageCode: 'en');
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.showAllDentists());
    },
  );

  test(
    'UT-REP-DOC-03 empty offline list produces localized no-cache error',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(() => local.getCachedDentists()).thenAnswer(
        (_) async => const ShowAllDentistsResponseModel(
          success: true,
          data: <DentistModel>[],
        ),
      );
      expect(
        repository.showAllDentists(languageCode: 'en'),
        throwsA(
          predicate(
            (e) =>
                e.toString().contains(NetworkErrorMessages.noCachedData('en')),
          ),
        ),
      );
    },
  );

  test(
    'UT-REP-DOC-04 online details returns value and caches by dentist id',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(
        () => remote.showDentistDetails(4),
      ).thenAnswer((_) async => detailsResponse);
      when(
        () => local.cacheDentistDetails(4, detailsResponse),
      ).thenAnswer((_) async {});
      final result = await repository.showDentistDetails(
        dentistId: 4,
        languageCode: 'ar',
      );
      expect(result.data.name, 'Dr. Lina');
      expect(result.isFromCache, isFalse);
      verify(() => local.cacheDentistDetails(4, detailsResponse)).called(1);
    },
  );

  test('UT-REP-DOC-05 offline details returns cached value', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(
      () => local.getCachedDentistDetails(4),
    ).thenAnswer((_) async => detailsResponse);
    final result = await repository.showDentistDetails(
      dentistId: 4,
      languageCode: 'ar',
    );
    expect(result.data.id, 4);
    expect(result.isFromCache, isTrue);
    verifyNever(() => remote.showDentistDetails(any()));
  });

  test(
    'UT-REP-DOC-06 online specialization list is cached separately',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(
        () => remote.showDentistsBySpecialization(2),
      ).thenAnswer((_) async => specialtyResponse);
      when(
        () => local.cacheDentistsBySpecialization(2, specialtyResponse),
      ).thenAnswer((_) async {});
      final result = await repository.showDentistsBySpecialization(
        specializationId: 2,
        languageCode: 'en',
      );
      expect(result.data, hasLength(1));
      expect(result.isFromCache, isFalse);
      verify(
        () => local.cacheDentistsBySpecialization(2, specialtyResponse),
      ).called(1);
    },
  );

  test('UT-REP-DOC-07 offline specialization list uses its cache', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(
      () => local.getCachedDentistsBySpecialization(2),
    ).thenAnswer((_) async => specialtyResponse);
    final result = await repository.showDentistsBySpecialization(
      specializationId: 2,
      languageCode: 'ar',
    );
    expect(result.isFromCache, isTrue);
    verifyNever(() => remote.showDentistsBySpecialization(any()));
  });

  test('UT-REP-DOC-08 show rating succeeds online', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.showDentistRate(4)).thenAnswer(
      (_) async => const ShowDentistRateResponseModel(success: true, rating: 4),
    );
    expect(
      await repository.showDentistRate(dentistId: 4, languageCode: 'ar'),
      4,
    );
  });

  test('UT-REP-DOC-09 show rating is rejected offline', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    expect(
      repository.showDentistRate(dentistId: 4, languageCode: 'en'),
      throwsA(
        predicate(
          (e) => e.toString().contains(NetworkErrorMessages.noInternet('en')),
        ),
      ),
    );
    verifyNever(() => remote.showDentistRate(any()));
  });

  test('UT-REP-DOC-10 add rating returns new average online', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.addDentistRate(dentistId: 4, rating: 5)).thenAnswer(
      (_) async => const AddDentistRateResponseModel(
        success: true,
        message: 'ok',
        averageRating: 4,
      ),
    );
    expect(
      await repository.addDentistRate(
        dentistId: 4,
        rating: 5,
        languageCode: 'ar',
      ),
      4,
    );
  });

  test('UT-REP-DOC-11 add rating is blocked offline before API call', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    expect(
      repository.addDentistRate(dentistId: 4, rating: 5, languageCode: 'ar'),
      throwsA(
        predicate(
          (e) => e.toString().contains(
            NetworkErrorMessages.offlineActionNotAllowed('ar'),
          ),
        ),
      ),
    );
    verifyNever(
      () => remote.addDentistRate(
        dentistId: any(named: 'dentistId'),
        rating: any(named: 'rating'),
      ),
    );
  });
}
