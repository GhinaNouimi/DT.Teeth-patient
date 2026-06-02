import '../../../data/models/register_patient_request_model.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterPatientSubmitted extends RegisterEvent {
  final RegisterPatientRequestModel request;

  const RegisterPatientSubmitted({required this.request});
}
