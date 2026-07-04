import 'dart:convert';

import '../../../../../core/cache/cache_keys.dart';
import '../../../../../core/cache/cache_service.dart';
import '../../models/prescription/prescription_model.dart';
import 'prescription_local_data_source.dart';

class PrescriptionLocalDataSourceImpl implements PrescriptionLocalDataSource {
  @override
  Future<void> cachePrescriptions(
      List<PrescriptionModel> prescriptions,
      ) async {
    await CacheService.saveString(
      key: CacheKeys.prescriptions,
      value: jsonEncode(
        prescriptions.map((item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<List<PrescriptionModel>> getCachedPrescriptions() async {
    final cached = await CacheService.getString(
      key: CacheKeys.prescriptions,
    );

    final decoded = jsonDecode(cached);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionModel.fromJson)
        .toList();
  }

  @override
  Future<void> cachePrescriptionDetails(
      PrescriptionModel prescription,
      ) async {
    await CacheService.saveString(
      key: '${CacheKeys.prescriptionDetailsPrefix}${prescription.id}',
      value: jsonEncode(prescription.toJson()),
    );
  }

  @override
  Future<PrescriptionModel?> getCachedPrescriptionDetails(
      int prescriptionId,
      ) async {
    final cached = await CacheService.getString(
      key: '${CacheKeys.prescriptionDetailsPrefix}$prescriptionId',
    );

    final decoded = jsonDecode(cached);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return PrescriptionModel.fromJson(decoded);
  }
}