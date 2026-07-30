// import '../../domain/entities/payment_plan_entity.dart';
// import 'payment_record_model.dart';
//
// class PaymentPlanModel {
//   final String id;
//   final String treatmentId;
//   final String treatmentName;
//   final String doctorName;
//   final String totalCostLabel;
//   final String paidAmountLabel;
//   final String remainingAmountLabel;
//   final int progressPercent;
//   final String expectedSessionsLabel;
//   final String durationLabel;
//   final List<PaymentRecordModel> records;
//
//   const PaymentPlanModel({
//     required this.id,
//     required this.treatmentId,
//     required this.treatmentName,
//     required this.doctorName,
//     required this.totalCostLabel,
//     required this.paidAmountLabel,
//     required this.remainingAmountLabel,
//     required this.progressPercent,
//     required this.expectedSessionsLabel,
//     required this.durationLabel,
//     required this.records,
//   });
//
//   PaymentPlanEntity toEntity() {
//     return PaymentPlanEntity(
//       id: id,
//       treatmentId: treatmentId,
//       treatmentName: treatmentName,
//       doctorName: doctorName,
//       totalCostLabel: totalCostLabel,
//       paidAmountLabel: paidAmountLabel,
//       remainingAmountLabel: remainingAmountLabel,
//       progressPercent: progressPercent,
//       expectedSessionsLabel: expectedSessionsLabel,
//       durationLabel: durationLabel,
//       records: records.map((record) => record.toEntity()).toList(),
//     );
//   }
// }
