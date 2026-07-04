import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/prescription/prescription_model.dart';
import 'prescription_remote_data_source.dart';

class PrescriptionRemoteDataSourceImpl
    implements PrescriptionRemoteDataSource {
  final Dio dio;

  PrescriptionRemoteDataSourceImpl({
    Dio? dio,
  }) : dio = dio ?? DioClient.dio;

  @override
  Future<List<PrescriptionModel>> getAllPrescriptions() async {
    final response = await dio.get(
      ApiConstants.patientShowAllPrescriptions,
    );

    final prescriptions =
    (response.data['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionModel.fromJson)
        .toList();

    return prescriptions;
  }

  @override
  Future<PrescriptionModel> getPrescriptionDetails(
      int prescriptionId,
      ) async {
    final response = await dio.get(
      ApiConstants.patientShowPrescriptionDetails(
        prescriptionId,
      ),
    );

    return PrescriptionModel.fromJson(
      response.data['data'],
    );
  }
}