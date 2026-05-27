import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/verify_email_usecase.dart';
import 'verify_email_event.dart';
import 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final VerifyEmailUseCase verifyEmailUseCase;
  final NetworkInfo networkInfo;

  VerifyEmailBloc({
    required this.verifyEmailUseCase,
    required this.networkInfo,
  }) : super(const VerifyEmailInitial()) {
    on<VerifyEmailSubmitted>(_onVerifyEmailSubmitted);
  }

  Future<void> _onVerifyEmailSubmitted(
      VerifyEmailSubmitted event,
      Emitter<VerifyEmailState> emit,
      ) async {
    emit(const VerifyEmailLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const VerifyEmailFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await verifyEmailUseCase(event.request);

      emit(VerifyEmailSuccess(response: response));
    } on DioException catch (error) {
      emit(
        VerifyEmailFailure(
          message: _extractDioErrorMessage(error),
        ),
      );
    } catch (_) {
      emit(
        const VerifyEmailFailure(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا',
        ),
      );
    }
  }

  String _extractDioErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message != null) {
        return message.toString();
      }

      final errors = data['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    return 'فشل التحقق من الرمز';
  }
}