import 'payment_record_entity.dart';

class PaymentPlanEntity {
  final String id;
  final String treatmentId;
  final String treatmentName;
  final String doctorName;
  final String totalCostLabel;
  final String paidAmountLabel;
  final String remainingAmountLabel;
  final int progressPercent;
  final String expectedSessionsLabel;
  final String durationLabel;
  final List<PaymentRecordEntity> records;

  const PaymentPlanEntity({
    required this.id,
    required this.treatmentId,
    required this.treatmentName,
    required this.doctorName,
    required this.totalCostLabel,
    required this.paidAmountLabel,
    required this.remainingAmountLabel,
    required this.progressPercent,
    required this.expectedSessionsLabel,
    required this.durationLabel,
    required this.records,
  });
}
