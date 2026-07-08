import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/treatment/treatment_model.dart';
import 'treatment_remote_data_source.dart';

class TreatmentRemoteDataSourceImpl implements TreatmentRemoteDataSource {
  final Dio dio;

  TreatmentRemoteDataSourceImpl({
    Dio? dio,
  }) : dio = dio ?? DioClient.dio;

  @override
  Future<List<TreatmentModel>> getAllTreatments() async {
    final response = await dio.get(
      ApiConstants.patientShowAllTreatments,
    );

    return (response.data['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(TreatmentModel.fromJson)
        .toList();
  }

  @override
  Future<TreatmentModel> getTreatmentDetails(int treatmentId) async {
    final response = await dio.get(
      ApiConstants.patientShowTreatmentDetails(treatmentId),
    );

    return TreatmentModel.fromJson(
      response.data['data'],
    );
  }
}