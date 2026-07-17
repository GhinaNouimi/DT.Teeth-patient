import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import 'data/datasources/local/appointments_local_data_source.dart';
import 'data/datasources/remote/appointments_remote_data_source.dart';
import 'data/datasources/remote/appointments_remote_data_source_impl.dart';
import 'data/repositories/appointments_repository_impl.dart';
import 'domain/repositories/appointments_repository.dart';
import 'domain/usecases/cancel_appointment_use_case.dart';
import 'domain/usecases/show_appointment_details_use_case.dart';
import 'domain/usecases/show_appointments_use_case.dart';
import 'domain/usecases/show_previous_appointments_use_case.dart';

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

  static final ShowAppointmentsUseCase showAppointmentsUseCase =
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

  static final CancelAppointmentUseCase cancelAppointmentUseCase =
  CancelAppointmentUseCase(
    repository: repository,
  );
}