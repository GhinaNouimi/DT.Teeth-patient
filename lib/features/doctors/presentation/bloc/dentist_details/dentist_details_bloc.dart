import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/show_dentist_details_usecase.dart';
import 'dentist_details_event.dart';
import 'dentist_details_state.dart';

class DentistDetailsBloc
    extends Bloc<DentistDetailsEvent, DentistDetailsState> {
  final ShowDentistDetailsUseCase showDentistDetailsUseCase;

  DentistDetailsBloc({
    required this.showDentistDetailsUseCase,
  }) : super(const DentistDetailsInitial()) {
    on<ShowDentistDetailsRequested>(_onShowDentistDetailsRequested);
  }

  Future<void> _onShowDentistDetailsRequested(
      ShowDentistDetailsRequested event,
      Emitter<DentistDetailsState> emit,
      ) async {
    emit(const DentistDetailsLoading());

    try {
      final dentist = await showDentistDetailsUseCase(
        dentistId: event.dentistId,
        languageCode: event.languageCode,
      );

      emit(DentistDetailsLoaded(dentist: dentist));
    } catch (error) {
      emit(
        DentistDetailsFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}