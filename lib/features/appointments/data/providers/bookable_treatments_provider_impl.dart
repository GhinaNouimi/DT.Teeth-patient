import 'package:flutter/cupertino.dart';

import '../../../../core/cache/cached_result.dart';
import '../../../medical_record/domain/entities/treatment/treatment_entity.dart';
import '../../../medical_record/domain/usecases/treatment/get_all_treatments_use_case.dart';
import '../../domain/entities/bookable_treatment_entity.dart';
import '../../domain/repositories/bookable_treatments_provider.dart';

class BookableTreatmentsProviderImpl
    implements BookableTreatmentsProvider {
  final GetAllTreatmentsUseCase
  getAllTreatmentsUseCase;

  const BookableTreatmentsProviderImpl({
    required this.getAllTreatmentsUseCase,
  });

  @override
  Future<CachedResult<List<BookableTreatmentEntity>>>
  getBookableTreatments({
    required String languageCode,
  }) async {
    final result = await getAllTreatmentsUseCase(
      languageCode: languageCode,
    );

    final bookableTreatments = result.data
        .where((treatment) => treatment.isOngoing)
        .map(_mapTreatment)
        .toList();

    if (result.isFromCache) {
      return CachedResult.cache(
        bookableTreatments,
      );
    }

    return CachedResult.remote(
      bookableTreatments,
    );
  }

  BookableTreatmentEntity _mapTreatment(
      TreatmentEntity treatment,
      ) {

    debugPrint(
      'TREATMENT ID: ${treatment.id}',
    );

    debugPrint(
      'DENTIST ID FROM TREATMENT: ${treatment.dentist.id}',
    );

    debugPrint(
      'DENTIST NAME FROM TREATMENT: "${treatment.dentist.name}"',
    );
    return BookableTreatmentEntity(
      id: treatment.id,
      treatmentTypeName:
      treatment.treatmentType.name,
      treatmentTypeNameEn:
      treatment.treatmentType.nameEn,
      dentistId: treatment.dentist.id,
      dentistName: treatment.dentist.name,
      totalSessionsNeeded:
      treatment.totalSessionsNeeded,
      sessionsCompleted:
      treatment.sessionsCompleted,
    );
  }
}