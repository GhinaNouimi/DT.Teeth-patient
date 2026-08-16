import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dt_teeth/features/appointments/presentaion/bloc/appointment_edit/appointment_edit_bloc.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../medical_record/medical_record_di.dart';
import 'data/datasources/local/appointments_local_data_source.dart';
import 'data/datasources/remote/appointments_remote_data_source.dart';
import 'data/datasources/remote/appointments_remote_data_source_impl.dart';
import 'data/providers/bookable_treatments_provider_impl.dart';
import 'data/repositories/appointments_repository_impl.dart';
import 'domain/repositories/appointments_repository.dart';
import 'domain/repositories/bookable_treatments_provider.dart';
import 'domain/usecases/add_appointment_use_case.dart';
import 'domain/usecases/cancel_appointment_use_case.dart';
import 'domain/usecases/get_bookable_treatments_use_case.dart';
import 'domain/usecases/show_appointment_details_use_case.dart';
import 'domain/usecases/show_appointment_types_use_case.dart';
import 'domain/usecases/show_appointments_use_case.dart';
import 'domain/usecases/show_dentist_schedule_use_case.dart';
import 'domain/usecases/show_dentists_by_appointment_type_use_case.dart';
import 'domain/usecases/show_previous_appointments_use_case.dart';
import 'domain/usecases/update_appointment_use_case.dart';
import 'presentaion/bloc/appointment_booking/appointment_booking_bloc.dart';

class AppointmentsDi {
  AppointmentsDi._();

  static final AppointmentsRemoteDataSource remoteDataSource =
  AppointmentsRemoteDataSourceImpl(
    dio: DioClient.dio,
  );

  static const AppointmentsLocalDataSource localDataSource =
  AppointmentsLocalDataSourceImpl();

  static final NetworkInfo networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  static final AppointmentsRepository repository =
  AppointmentsRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  // ==================== Appointment Queries ====================

  static final ShowAppointmentsUseCase
  showAppointmentsUseCase =
  ShowAppointmentsUseCase(
    repository: repository,
  );

  static final ShowPreviousAppointmentsUseCase
  showPreviousAppointmentsUseCase =
  ShowPreviousAppointmentsUseCase(
    repository: repository,
  );

  static final ShowAppointmentDetailsUseCase
  showAppointmentDetailsUseCase =
  ShowAppointmentDetailsUseCase(
    repository: repository,
  );

  static final ShowAppointmentTypesUseCase
  showAppointmentTypesUseCase =
  ShowAppointmentTypesUseCase(
    repository: repository,
  );

  static final ShowDentistsByAppointmentTypeUseCase
  showDentistsByAppointmentTypeUseCase =
  ShowDentistsByAppointmentTypeUseCase(
    repository: repository,
  );

  static final ShowDentistScheduleUseCase
  showDentistScheduleUseCase =
  ShowDentistScheduleUseCase(
    repository: repository,
  );

  // ==================== Appointment Actions ====================

  static final AddAppointmentUseCase
  addAppointmentUseCase =
  AddAppointmentUseCase(
    repository: repository,
  );

  static final UpdateAppointmentUseCase
  updateAppointmentUseCase =
  UpdateAppointmentUseCase(
    repository: repository,
  );

  static final CancelAppointmentUseCase
  cancelAppointmentUseCase =
  CancelAppointmentUseCase(
    repository: repository,
  );

  // ==================== Bookable Treatments ====================

  static final BookableTreatmentsProvider
  bookableTreatmentsProvider =
  BookableTreatmentsProviderImpl(
    getAllTreatmentsUseCase:
    MedicalRecordDi.getAllTreatmentsUseCase,
  );

  static final GetBookableTreatmentsUseCase
  getBookableTreatmentsUseCase =
  GetBookableTreatmentsUseCase(
    provider: bookableTreatmentsProvider,
  );

// ==================== BLoC Factories ====================

  static AppointmentBookingBloc
  createAppointmentBookingBloc() {
    return AppointmentBookingBloc(
      showAppointmentTypesUseCase:
      showAppointmentTypesUseCase,
      showDentistsByAppointmentTypeUseCase:
      showDentistsByAppointmentTypeUseCase,
      showDentistScheduleUseCase:
      showDentistScheduleUseCase,
      addAppointmentUseCase:
      addAppointmentUseCase,
      getBookableTreatmentsUseCase:
      getBookableTreatmentsUseCase,
    );
  }

  static AppointmentEditBloc
  createAppointmentEditBloc() {
    return AppointmentEditBloc(
      showAppointmentDetailsUseCase:
      showAppointmentDetailsUseCase,
      showDentistScheduleUseCase:
      showDentistScheduleUseCase,
      updateAppointmentUseCase:
      updateAppointmentUseCase,
    );
  }
}