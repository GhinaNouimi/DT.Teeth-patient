import '../../domain/entities/applicable_treatment_entity.dart';
import '../../domain/entities/offer_entity.dart';

enum OffersStatus {
  initial,
  loading,
  success,
  failure,
}

enum OfferActionStatus {
  initial,
  loadingTreatments,
  treatmentsLoaded,
  applying,
  applySuccess,
  failure,
}

class OffersState {
  final OffersStatus offersStatus;
  final OfferActionStatus actionStatus;

  final List<OfferEntity> offers;

  final List<ApplicableTreatmentEntity>
  applicableTreatments;

  final bool isFromCache;

  final int? selectedTreatmentTypeId;
  final int? selectedTreatmentId;

  final String? offersErrorMessage;
  final String? actionErrorMessage;
  final String? successMessage;

  const OffersState({
    this.offersStatus = OffersStatus.initial,
    this.actionStatus = OfferActionStatus.initial,
    this.offers = const [],
    this.applicableTreatments = const [],
    this.isFromCache = false,
    this.selectedTreatmentTypeId,
    this.selectedTreatmentId,
    this.offersErrorMessage,
    this.actionErrorMessage,
    this.successMessage,
  });

  OffersState copyWith({
    OffersStatus? offersStatus,
    OfferActionStatus? actionStatus,
    List<OfferEntity>? offers,
    List<ApplicableTreatmentEntity>?
    applicableTreatments,
    bool? isFromCache,

    int? selectedTreatmentTypeId,
    bool clearSelectedTreatmentTypeId = false,

    int? selectedTreatmentId,
    bool clearSelectedTreatmentId = false,

    String? offersErrorMessage,
    bool clearOffersErrorMessage = false,

    String? actionErrorMessage,
    bool clearActionErrorMessage = false,

    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return OffersState(
      offersStatus:
      offersStatus ?? this.offersStatus,
      actionStatus:
      actionStatus ?? this.actionStatus,
      offers: offers ?? this.offers,
      applicableTreatments:
      applicableTreatments ??
          this.applicableTreatments,
      isFromCache:
      isFromCache ?? this.isFromCache,

      selectedTreatmentTypeId:
      clearSelectedTreatmentTypeId
          ? null
          : selectedTreatmentTypeId ??
          this.selectedTreatmentTypeId,

      selectedTreatmentId:
      clearSelectedTreatmentId
          ? null
          : selectedTreatmentId ??
          this.selectedTreatmentId,

      offersErrorMessage:
      clearOffersErrorMessage
          ? null
          : offersErrorMessage ??
          this.offersErrorMessage,

      actionErrorMessage:
      clearActionErrorMessage
          ? null
          : actionErrorMessage ??
          this.actionErrorMessage,

      successMessage:
      clearSuccessMessage
          ? null
          : successMessage ??
          this.successMessage,
    );
  }
}