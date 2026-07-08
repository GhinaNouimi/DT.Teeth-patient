import '../../models/treatment/treatment_model.dart';

abstract class TreatmentRemoteDataSource {
  Future<List<TreatmentModel>> getAllTreatments();

  Future<TreatmentModel> getTreatmentDetails(int treatmentId);
}