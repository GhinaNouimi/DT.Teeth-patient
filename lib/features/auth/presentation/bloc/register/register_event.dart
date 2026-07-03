import '../../../data/models/register_patient_request_model.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterPatientSubmitted extends RegisterEvent {
  final RegisterPatientRequestModel request;
  final String languageCode;

  const RegisterPatientSubmitted({
    required this.request,
    required this.languageCode,
  });
}