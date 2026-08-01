import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';

import 'data/datasources/local/offers_local_data_source.dart';
import 'data/datasources/local/offers_local_data_source_impl.dart';

import 'data/datasources/remote/offers_remote_data_source.dart';

import 'data/repositories/offers_repository_impl.dart';

import 'domain/repositories/offers_repository.dart';

import 'domain/usecases/apply_to_offer_use_case.dart';
import 'domain/usecases/get_treatments_by_type_use_case.dart';
import 'domain/usecases/show_offers_use_case.dart';

abstract final class OffersDi {
  static final NetworkInfo _networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  // ==================== Data Sources ====================

  static final OffersRemoteDataSource
  _offersRemoteDataSource =
  OffersRemoteDataSourceImpl();

  static final OffersLocalDataSource
  _offersLocalDataSource =
  OffersLocalDataSourceImpl();

  // ==================== Repository ====================

  static final OffersRepository _offersRepository =
  OffersRepositoryImpl(
    remoteDataSource: _offersRemoteDataSource,
    localDataSource: _offersLocalDataSource,
    networkInfo: _networkInfo,
  );

  // ==================== Use Cases ====================

  static final ShowOffersUseCase showOffersUseCase =
  ShowOffersUseCase(
    _offersRepository,
  );

  static final GetTreatmentsByTypeUseCase
  getTreatmentsByTypeUseCase =
  GetTreatmentsByTypeUseCase(
    _offersRepository,
  );

  static final ApplyToOfferUseCase applyToOfferUseCase =
  ApplyToOfferUseCase(
    _offersRepository,
  );
}