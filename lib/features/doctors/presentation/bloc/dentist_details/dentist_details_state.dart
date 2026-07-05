import '../../../../../core/cache/cached_result.dart';
import '../../../domain/entities/dentist_details_entity.dart';

abstract class DentistDetailsState {
  const DentistDetailsState();
}

class DentistDetailsInitial extends DentistDetailsState {
  const DentistDetailsInitial();
}

class DentistDetailsLoading extends DentistDetailsState {
  const DentistDetailsLoading();
}

class DentistDetailsLoaded extends DentistDetailsState {
  final CachedResult<DentistDetailsEntity> dentist;

  const DentistDetailsLoaded({
    required this.dentist,
  });
}

class DentistDetailsFailure extends DentistDetailsState {
  final String message;

  const DentistDetailsFailure({
    required this.message,
  });
}