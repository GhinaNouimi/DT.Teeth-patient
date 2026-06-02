import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
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
    } catch (error) {
      emit(RegisterFailure(message: ApiErrorHandler.handle(error)));
    }
  }
}