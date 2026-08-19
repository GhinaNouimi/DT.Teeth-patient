import 'package:dt_teeth/core/cache/cache_exception.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/core/network/offline_exception.dart';
import 'package:dt_teeth/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:dt_teeth/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:dt_teeth/features/profile/data/models/profile_model.dart';
import 'package:dt_teeth/features/profile/data/models/update_profile_request_model.dart';
import 'package:dt_teeth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:dt_teeth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

ProfileModel profileModel({String name = 'Ghina'}) => ProfileModel(
  id: '12',
  userId: '40',
  name: name,
  email: 'ghina@example.com',
  phone: '0999999999',
  dateOfBirth: '2000-01-02',
  gender: 2,
  address: 'Damascus',
  profilePicture: 'profile.jpg',
  emergencyContactName: 'Rama',
  emergencyContactRelation: 'Sister',
  emergencyContactPhone: '0988888888',
  isPregnant: false,
  isBreastfeeding: false,
  isSmoker: false,
  drinksAlcoholFrequently: false,
  teethCleaningFrequency: 'twice_daily',
  allergies: const <String>[],
  chronicDiseases: const <String>[],
  medications: const <String>[],
  isDarkModeEnabled: false,
  languageCode: 'ar',
);

void main() {
  late MockProfileRemoteDataSource remote;
  late MockProfileLocalDataSource local;
  late MockNetworkInfo network;
  late ProfileRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(profileModel());
    registerFallbackValue(
      const UpdateProfileRequestModel(
        name: '',
        phone: '',
        dateOfBirth: '',
        gender: -1,
        address: '',
        emergencyContactName: '',
        emergencyContactRelation: '',
        emergencyContactPhone: '',
        isPregnant: false,
        isBreastfeeding: false,
        isSmoker: false,
        drinksAlcoholFrequently: false,
        teethCleaningFrequency: '',
      ),
    );
  });

  setUp(() {
    remote = MockProfileRemoteDataSource();
    local = MockProfileLocalDataSource();
    network = MockNetworkInfo();
    repository = ProfileRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
      networkInfo: network,
    );
  });

  test(
    'UT-REP-PRO-01 online read returns remote profile and refreshes cache',
    () async {
      final model = profileModel();
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remote.getProfile()).thenAnswer((_) async => model);
      when(() => local.cacheProfile(model)).thenAnswer((_) async {});

      final result = await repository.getProfile();

      expect(result.data.name, 'Ghina');
      expect(result.isFromCache, isFalse);
      verify(() => remote.getProfile()).called(1);
      verify(() => local.cacheProfile(model)).called(1);
      verifyNever(() => local.getCachedProfile());
    },
  );

  test(
    'UT-REP-PRO-02 offline read returns cache and never calls API',
    () async {
      final cached = profileModel(name: 'Cached Ghina');
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(() => local.getCachedProfile()).thenAnswer((_) async => cached);

      final result = await repository.getProfile();

      expect(result.data.name, 'Cached Ghina');
      expect(result.isFromCache, isTrue);
      verifyNever(() => remote.getProfile());
    },
  );

  test(
    'UT-REP-PRO-03 offline without cache propagates CacheException',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(() => local.getCachedProfile()).thenThrow(const CacheException());

      expect(repository.getProfile(), throwsA(isA<CacheException>()));
      verifyNever(() => remote.getProfile());
    },
  );

  test(
    'UT-REP-PRO-04 online update maps entity, caches response, and returns it',
    () async {
      final input = profileModel().toEntity().copyWith(name: 'Updated Ghina');
      final response = profileModel(name: 'Updated Ghina');
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remote.updateProfile(any())).thenAnswer((_) async => response);
      when(() => local.cacheProfile(response)).thenAnswer((_) async {});

      final result = await repository.updateProfile(input);

      expect(result.name, 'Updated Ghina');
      final captured =
          verify(() => remote.updateProfile(captureAny())).captured.single
              as UpdateProfileRequestModel;
      expect(captured.name, 'Updated Ghina');
      expect(captured.phone, input.phone);
      expect(captured.gender, input.gender);
      verify(() => local.cacheProfile(response)).called(1);
    },
  );

  test(
    'UT-REP-PRO-05 offline update is blocked before API and cache',
    () async {
      final ProfileEntity input = profileModel().toEntity();
      when(() => network.isConnected).thenAnswer((_) async => false);

      expect(repository.updateProfile(input), throwsA(isA<OfflineException>()));
      verifyNever(() => remote.updateProfile(any()));
      verifyNever(() => local.cacheProfile(any()));
    },
  );
}
