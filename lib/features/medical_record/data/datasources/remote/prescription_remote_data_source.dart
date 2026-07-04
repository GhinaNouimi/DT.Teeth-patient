import '../../models/prescription/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getAllPrescriptions();

  Future<PrescriptionModel> getPrescriptionDetails(
      int prescriptionId,
      );
}