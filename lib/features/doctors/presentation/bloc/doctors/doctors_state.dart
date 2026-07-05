import '../../../../../core/cache/cached_result.dart';
import '../../../domain/entities/dentist_details_entity.dart';
import '../../../domain/entities/dentist_entity.dart';

abstract class DoctorsState {
  const DoctorsState();
}

class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

class DoctorsLoaded extends DoctorsState {
  final CachedResult<List<DentistEntity>> dentists;

  const DoctorsLoaded({
    required this.dentists,
  });
}

class DentistsBySpecializationLoaded extends DoctorsState {
  final CachedResult<List<DentistDetailsEntity>> dentists;

  const DentistsBySpecializationLoaded({
    required this.dentists,
  });
}

class DoctorsFailure extends DoctorsState {
  final String message;

  const DoctorsFailure({
    required this.message,
  });
}