import 'treatment_procedure_entity.dart';

class ToothTreatmentEntity {
  final int id;
  final int toothNumber;
  final TreatmentProcedureEntity procedure;
  final String? notes;

  const ToothTreatmentEntity({
    required this.id,
    required this.toothNumber,
    required this.procedure,
    this.notes,
  });
}