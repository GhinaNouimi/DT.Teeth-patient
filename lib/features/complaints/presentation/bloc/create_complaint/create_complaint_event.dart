import '../../../domain/entities/add_complaint_params.dart';

sealed class CreateComplaintEvent {
  const CreateComplaintEvent();
}

final class SubmitComplaintRequested
    extends CreateComplaintEvent {
  final AddComplaintParams params;
  final String languageCode;

  const SubmitComplaintRequested({
    required this.params,
    required this.languageCode,
  });
}

final class CreateComplaintStateResetRequested
    extends CreateComplaintEvent {
  const CreateComplaintStateResetRequested();
}