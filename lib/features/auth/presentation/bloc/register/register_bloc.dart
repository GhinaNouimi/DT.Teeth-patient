import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/register_patient_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterPatientUseCase registerPatientUseCase;
  final NetworkInfo networkInfo;

  RegisterBloc({
    required this.registerPatientUseCase,
    required this.networkInfo,
  }) : super(const RegisterInitial()) {
    on<RegisterPatientSubmitted>(_onRegisterPatientSubmitted);
  }

  Future<void> _onRegisterPatientSubmitted(
      RegisterPatientSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(const RegisterLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const RegisterFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await registerPatientUseCase(event.request);

      emit(RegisterSuccess(response: response));
    } on DioException catch (error) {
      emit(
        RegisterFailure(
          message: _extractDioErrorMessage(error),
        ),
      );
    } catch (_) {
      emit(
        const RegisterFailure(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا',
        ),
      );
    }
  }

  String _extractDioErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message != null) {
        return message.toString();
      }

      final errors = responseData['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    return 'تعذر الاتصال بالخادم، تحقق من الاتصال وحاول مجددًا';
  }
}