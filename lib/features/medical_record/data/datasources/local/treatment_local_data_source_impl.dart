import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/treatment/treatment_model.dart';
import 'treatment_local_data_source.dart';

class TreatmentLocalDataSourceImpl implements TreatmentLocalDataSource {
  @override
  Future<void> cacheTreatments(List<TreatmentModel> treatments) async {
    await CacheService.saveString(
      key: CacheKeys.treatments,
      value: jsonEncode(
        treatments.map((item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<List<TreatmentModel>> getCachedTreatments() async {
    final cached = await CacheService.getString(
      key: CacheKeys.treatments,
    );

    final decoded = jsonDecode(cached);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(TreatmentModel.fromJson)
        .toList();
  }

  @override
  Future<void> cacheTreatmentDetails(TreatmentModel treatment) async {
    await CacheService.saveString(
      key: '${CacheKeys.treatmentDetailsPrefix}${treatment.id}',
      value: jsonEncode(treatment.toJson()),
    );
  }

  @override
  Future<TreatmentModel?> getCachedTreatmentDetails(int treatmentId) async {
    final cached = await CacheService.getString(
      key: '${CacheKeys.treatmentDetailsPrefix}$treatmentId',
    );

    final decoded = jsonDecode(cached);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return TreatmentModel.fromJson(decoded);
  }
}