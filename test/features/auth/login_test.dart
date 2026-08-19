import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/features/auth/data/models/login_request_model.dart';
import 'package:dt_teeth/features/auth/data/models/login_response_model.dart';
import 'package:dt_teeth/features/auth/data/repositories/auth_repository.dart';
import 'package:dt_teeth/features/auth/domain/usecases/login_patient_usecase.dart';
import 'package:dt_teeth/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:dt_teeth/features/auth/presentation/bloc/login/login_event.dart';
import 'package:dt_teeth/features/auth/presentation/bloc/login/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginPatientUseCase extends Mock implements LoginPatientUseCase {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

const request = LoginRequestModel(
  email: 'patient@example.com',
  password: 'Strong1!',
);

const response = LoginResponseModel(
  message: 'Logged in successfully',
  user: LoginUserModel(
    id: 7,
    name: 'Patient Name',
    email: 'patient@example.com',
    role: 5,
  ),
  token: 'secure-token',
  tokenType: 'Bearer',
);

void main() {
  group('login models', () {
    test('UT-AUTH-01 LoginRequestModel creates the expected API body', () {
      expect(request.toJson(), <String, dynamic>{
        'email': 'patient@example.com',
        'password': 'Strong1!',
      });
    });

    test('UT-AUTH-02 LoginResponseModel parses user and token data', () {
      final model = LoginResponseModel.fromJson(<String, dynamic>{
        'message': 'Logged in successfully',
        'user': <String, dynamic>{
          'id': 7,
          'name': 'Patient Name',
          'email': 'patient@example.com',
          'role': 5,
        },
        'token': 'secure-token',
        'token_type': 'Bearer',
      });

      expect(model.message, 'Logged in successfully');
      expect(model.user.id, 7);
      expect(model.user.email, 'patient@example.com');
      expect(model.token, 'secure-token');
      expect(model.tokenType, 'Bearer');
    });

    test(
      'UT-AUTH-03 LoginResponseModel uses safe defaults for missing fields',
      () {
        final model = LoginResponseModel.fromJson(<String, dynamic>{});

        expect(model.message, isEmpty);
        expect(model.user.id, 0);
        expect(model.user.name, isEmpty);
        expect(model.token, isEmpty);
        expect(model.tokenType, 'Bearer');
      },
    );
  });

  test(
    'UT-AUTH-04 LoginPatientUseCase forwards request and response',
    () async {
      final repository = MockAuthRepository();
      when(
        () => repository.loginPatient(request),
      ).thenAnswer((_) async => response);

      final result = await LoginPatientUseCase(repository: repository)(request);

      expect(result, same(response));
      verify(() => repository.loginPatient(request)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  group('LoginBloc', () {
    late MockLoginPatientUseCase loginUseCase;
    late MockNetworkInfo networkInfo;

    LoginBloc buildBloc() {
      return LoginBloc(
        loginPatientUseCase: loginUseCase,
        networkInfo: networkInfo,
      );
    }

    setUp(() {
      loginUseCase = MockLoginPatientUseCase();
      networkInfo = MockNetworkInfo();
    });

    test('BT-AUTH-01 starts with LoginInitial', () async {
      final bloc = buildBloc();

      expect(bloc.state, isA<LoginInitial>());

      await bloc.close();
    });

    blocTest<LoginBloc, LoginState>(
      'BT-AUTH-02 offline login emits Loading then localized Failure',
      setUp: () {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginPatientSubmitted(request: request, languageCode: 'ar'),
      ),
      expect: () => <dynamic>[
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      ],
      verify: (_) => verifyZeroInteractions(loginUseCase),
    );

    blocTest<LoginBloc, LoginState>(
      'BT-AUTH-03 connected valid login emits Loading then Success',
      setUp: () {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => loginUseCase(request)).thenAnswer((_) async => response);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginPatientSubmitted(request: request, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<LoginLoading>(),
        isA<LoginSuccess>()
            .having((state) => state.response.token, 'token', 'secure-token')
            .having(
              (state) => state.response.user.email,
              'email',
              'patient@example.com',
            ),
      ],
      verify: (_) => verify(() => loginUseCase(request)).called(1),
    );

    blocTest<LoginBloc, LoginState>(
      'BT-AUTH-04 invalid credentials are converted into a safe Failure message',
      setUp: () {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(() => loginUseCase(request)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/login'),
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 400,
              data: <String, dynamic>{'message': 'Invalid credentials'},
            ),
          ),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginPatientSubmitted(request: request, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'Email or password is incorrect.',
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'BT-AUTH-05 server failure does not expose technical details',
      setUp: () {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => loginUseCase(request),
        ).thenThrow(Exception('internal authentication stack trace'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LoginPatientSubmitted(request: request, languageCode: 'en'),
      ),
      expect: () => <dynamic>[
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'An unexpected error occurred. Please try again later.',
        ),
      ],
    );
  });
}
