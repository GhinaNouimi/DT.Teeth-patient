import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/cache/cache_exception.dart';
import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:dt_teeth/core/network/network_error_messages.dart';
import 'package:dt_teeth/core/network/offline_exception.dart';
import 'package:dt_teeth/features/profile/domain/entities/profile_entity.dart';
import 'package:dt_teeth/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:dt_teeth/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:dt_teeth/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:dt_teeth/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:dt_teeth/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

const profile = ProfileEntity(
  id: '12',
  userId: '40',
  name: 'Ghina',
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
  allergies: <String>[],
  chronicDiseases: <String>[],
  medications: <String>[],
  isDarkModeEnabled: false,
  languageCode: 'ar',
);

void main() {
  late MockGetProfileUseCase getProfile;
  late MockUpdateProfileUseCase updateProfile;

  ProfileBloc buildBloc() => ProfileBloc(
    getProfileUseCase: getProfile,
    updateProfileUseCase: updateProfile,
  );

  setUpAll(() => registerFallbackValue(profile));
  setUp(() {
    getProfile = MockGetProfileUseCase();
    updateProfile = MockUpdateProfileUseCase();
  });

  test('BT-PRO-00 initial state is ProfileInitial', () async {
    final bloc = buildBloc();
    expect(bloc.state, isA<ProfileInitial>());
    await bloc.close();
  });

  blocTest<ProfileBloc, ProfileState>(
    'BT-PRO-01 load from API emits Loading then non-cached Loaded',
    setUp: () => when(() => getProfile()).thenAnswer(
      (_) async => const CachedResult<ProfileEntity>.remote(profile),
    ),
    build: buildBloc,
    act: (bloc) => bloc.add(const LoadProfileRequested(languageCode: 'ar')),
    expect: () => <dynamic>[
      isA<ProfileLoading>(),
      isA<ProfileLoaded>()
          .having((state) => state.profile.name, 'name', 'Ghina')
          .having((state) => state.isFromCache, 'cache flag', isFalse),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'BT-PRO-02 load from cache preserves the cache evidence flag',
    setUp: () => when(
      () => getProfile(),
    ).thenAnswer((_) async => const CachedResult<ProfileEntity>.cache(profile)),
    build: buildBloc,
    act: (bloc) => bloc.add(const LoadProfileRequested(languageCode: 'en')),
    expect: () => <dynamic>[
      isA<ProfileLoading>(),
      isA<ProfileLoaded>().having(
        (state) => state.isFromCache,
        'cache flag',
        isTrue,
      ),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'BT-PRO-03 missing offline cache emits a clear localized failure',
    setUp: () => when(() => getProfile()).thenThrow(const CacheException()),
    build: buildBloc,
    act: (bloc) => bloc.add(const LoadProfileRequested(languageCode: 'en')),
    expect: () => <dynamic>[
      isA<ProfileLoading>(),
      isA<ProfileFailure>().having(
        (state) => state.message,
        'message',
        NetworkErrorMessages.noCachedData('en'),
      ),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'BT-PRO-04 successful update emits Updating, Success, then Loaded',
    setUp: () => when(
      () => updateProfile(any(), profilePicture: any(named: 'profilePicture')),
    ).thenAnswer((_) async => profile.copyWith(name: 'Updated Ghina')),
    build: buildBloc,
    act: (bloc) => bloc.add(
      const UpdateProfileRequested(profile: profile, languageCode: 'ar'),
    ),
    expect: () => <dynamic>[
      isA<ProfileUpdating>(),
      isA<ProfileUpdateSuccess>().having(
        (state) => state.profile.name,
        'updated name',
        'Updated Ghina',
      ),
      isA<ProfileLoaded>()
          .having(
            (state) => state.profile.name,
            'updated name',
            'Updated Ghina',
          )
          .having((state) => state.isFromCache, 'cache flag', isFalse),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'BT-PRO-05 offline update emits localized failure instead of fake success',
    setUp: () => when(
      () => updateProfile(any(), profilePicture: any(named: 'profilePicture')),
    ).thenThrow(const OfflineException()),
    build: buildBloc,
    act: (bloc) => bloc.add(
      const UpdateProfileRequested(profile: profile, languageCode: 'ar'),
    ),
    expect: () => <dynamic>[
      isA<ProfileUpdating>(),
      isA<ProfileFailure>().having(
        (state) => state.message,
        'message',
        NetworkErrorMessages.offlineActionNotAllowed('ar'),
      ),
    ],
  );
}
