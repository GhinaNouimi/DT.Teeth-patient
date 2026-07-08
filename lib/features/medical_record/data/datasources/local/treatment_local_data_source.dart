import '../../models/treatment/treatment_model.dart';

abstract class TreatmentLocalDataSource {
  Future<void> cacheTreatments(List<TreatmentModel> treatments);

  Future<List<TreatmentModel>> getCachedTreatments();

  Future<void> cacheTreatmentDetails(TreatmentModel treatment);

  Future<TreatmentModel?> getCachedTreatmentDetails(int treatmentId);
}