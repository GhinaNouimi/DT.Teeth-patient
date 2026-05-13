import '../entities/payment_plan_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetPaymentPlanUseCase {
  final MedicalRecordRepository _repository;

  const GetPaymentPlanUseCase(this._repository);

  Future<PaymentPlanEntity?> call() {
    return _repository.getPaymentPlan();
  }
}
