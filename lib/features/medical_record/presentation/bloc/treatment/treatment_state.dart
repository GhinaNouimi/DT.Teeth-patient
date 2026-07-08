import '../../../domain/entities/treatment/treatment_entity.dart';

abstract class TreatmentState {
  const TreatmentState();
}

class TreatmentInitial extends TreatmentState {
  const TreatmentInitial();
}

class TreatmentLoading extends TreatmentState {
  const TreatmentLoading();
}

class TreatmentsLoaded extends TreatmentState {
  final List<TreatmentEntity> treatments;
  final bool isFromCache;

  const TreatmentsLoaded({
    required this.treatments,
    required this.isFromCache,
  });
}

class TreatmentDetailsLoaded extends TreatmentState {
  final TreatmentEntity treatment;
  final bool isFromCache;

  const TreatmentDetailsLoaded({
    required this.treatment,
    required this.isFromCache,
  });
}

class TreatmentFailure extends TreatmentState {
  final String message;

  const TreatmentFailure({
    required this.message,
  });
}