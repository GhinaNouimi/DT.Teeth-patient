import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/show_all_dentists_usecase.dart';
import '../../../domain/usecases/show_dentists_by_specialization_usecase.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final ShowAllDentistsUseCase showAllDentistsUseCase;
  final ShowDentistsBySpecializationUseCase
  showDentistsBySpecializationUseCase;

  DoctorsBloc({
    required this.showAllDentistsUseCase,
    required this.showDentistsBySpecializationUseCase,
  }) : super(const DoctorsInitial()) {
    on<ShowAllDentistsRequested>(_onShowAllDentistsRequested);
    on<ShowDentistsBySpecializationRequested>(
      _onShowDentistsBySpecializationRequested,
    );
  }

  Future<void> _onShowAllDentistsRequested(
      ShowAllDentistsRequested event,
      Emitter<DoctorsState> emit,
      ) async {
    emit(const DoctorsLoading());

    try {
      final dentists = await showAllDentistsUseCase(
        languageCode: event.languageCode,
      );

      emit(DoctorsLoaded(dentists: dentists));
    } catch (error) {
      emit(
        DoctorsFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onShowDentistsBySpecializationRequested(
      ShowDentistsBySpecializationRequested event,
      Emitter<DoctorsState> emit,
      ) async {
    emit(const DoctorsLoading());

    try {
      final dentists = await showDentistsBySpecializationUseCase(
        specializationId: event.specializationId,
        languageCode: event.languageCode,
      );

      emit(DentistsBySpecializationLoaded(dentists: dentists));
    } catch (error) {
      emit(
        DoctorsFailure(
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}