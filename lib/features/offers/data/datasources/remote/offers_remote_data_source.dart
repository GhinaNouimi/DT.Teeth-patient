
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/applicable_treatment_model.dart';
import '../../models/offer_model.dart';

abstract class OffersRemoteDataSource {
  Future<List<OfferModel>> showOffers();

  Future<List<ApplicableTreatmentModel>> treatmentsByType({
    required int treatmentTypeId,
  });

  Future<String> applyToOffer({
    required int offerId,
    required int treatmentId,
  });
}

class OffersRemoteDataSourceImpl
    implements OffersRemoteDataSource {
  const OffersRemoteDataSourceImpl();

  @override
  Future<List<OfferModel>> showOffers() async {
    final response = await DioClient.dio.get(
      ApiConstants.patientShowOffers,
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid offers response format.',
      );
    }

    final data = responseData['data'];

    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(OfferModel.fromJson)
        .toList();
  }

  @override
  Future<List<ApplicableTreatmentModel>> treatmentsByType({
    required int treatmentTypeId,
  }) async {
    final response = await DioClient.dio.get(
      ApiConstants.patientTreatmentsByType(
        treatmentTypeId,
      ),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid treatments response format.',
      );
    }

    final data = responseData['data'];

    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(
      ApplicableTreatmentModel.fromJson,
    )
        .toList();
  }

  @override
  Future<String> applyToOffer({
    required int offerId,
    required int treatmentId,
  }) async {
    final response = await DioClient.dio.post(
      ApiConstants.patientApplyToOffer(
        offerId,
      ),
      data: {
        'treatment_id': treatmentId,
      },
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid apply offer response format.',
      );
    }

    return responseData['message']?.toString() ?? '';
  }
}