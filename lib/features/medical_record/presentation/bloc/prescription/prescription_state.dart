import '../../../domain/entities/prescription/prescription_entity.dart';

abstract class PrescriptionState {
  const PrescriptionState();
}

class PrescriptionInitial extends PrescriptionState {
  const PrescriptionInitial();
}

class PrescriptionLoading extends PrescriptionState {
  const PrescriptionLoading();
}

class PrescriptionsLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  final bool isFromCache;

  const PrescriptionsLoaded({
    required this.prescriptions,
    required this.isFromCache,
  });
}

class PrescriptionDetailsLoaded extends PrescriptionState {
  final PrescriptionEntity prescription;
  final bool isFromCache;

  const PrescriptionDetailsLoaded({
    required this.prescription,
    required this.isFromCache,
  });
}

class PrescriptionFailure extends PrescriptionState {
  final String message;

  const PrescriptionFailure({
    required this.message,
  });
}