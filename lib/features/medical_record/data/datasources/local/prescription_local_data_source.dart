import '../../models/prescription/prescription_model.dart';

abstract class PrescriptionLocalDataSource {
  Future<void> cachePrescriptions(List<PrescriptionModel> prescriptions);

  Future<List<PrescriptionModel>> getCachedPrescriptions();

  Future<void> cachePrescriptionDetails(PrescriptionModel prescription);

  Future<PrescriptionModel?> getCachedPrescriptionDetails(int prescriptionId);
}