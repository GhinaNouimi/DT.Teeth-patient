import '../../domain/entities/attachment_entity.dart';
import '../../domain/entities/payment_record_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/entities/treatment_entity.dart';
import '../../domain/entities/treatment_timeline_step_entity.dart';
import '../models/attachment_model.dart';
import '../models/payment_plan_model.dart';
import '../models/payment_record_model.dart';
import '../models/prescription_model.dart';
import '../models/treatment_appointment_model.dart';
import '../models/treatment_model.dart';
import '../models/treatment_timeline_step_model.dart';

class MedicalRecordMockDataSource {
  const MedicalRecordMockDataSource();

  Future<List<TreatmentModel>> getTreatments() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _treatments;
  }

  Future<TreatmentModel?> getTreatmentById(String treatmentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    try {
      return _treatments.firstWhere((treatment) => treatment.id == treatmentId);
    } catch (_) {
      return null;
    }
  }

  Future<List<AttachmentModel>> getAttachmentsByTreatment(
    String treatmentId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _attachments
        .where((attachment) => attachment.treatmentId == treatmentId)
        .toList();
  }

  Future<List<PrescriptionModel>> getPrescriptions() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _prescriptions;
  }

  Future<PrescriptionModel?> getPrescriptionById(String prescriptionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    try {
      return _prescriptions.firstWhere(
        (prescription) => prescription.id == prescriptionId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<PaymentPlanModel?> getPaymentPlan() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _paymentPlan;
  }
}

const List<TreatmentModel> _treatments = [
  TreatmentModel(
    id: 'tr-ortho-01',
    name: 'تقويم الأسنان',
    doctorName: 'د. أحمد علي',
    statusLabel: 'قيد المتابعة',
    status: TreatmentStatus.active,
    type: TreatmentType.braces,
    completedSessions: 6,
    totalSessions: 18,
    progressPercent: 33,
    startedAtLabel: '12 مارس 2026',
    nextSessionLabel: '20 مايو 2026 - 05:00 م',
    summary:
        'خطة علاج تقويمية لتحسين الاصطفاف وإغلاق الفراغات الأمامية بشكل تدريجي.',
    completedProcedures: [
      'الفحص الأولي والتقييم',
      'الصور الشعاعية والفوتوغرافية',
      'تركيب التقويم العلوي والسفلي',
      '3 جلسات شد ومتابعة',
    ],
    careInstructions: [
      'استخدم الفرشاة الخاصة بالتقويم بعد كل وجبة.',
      'تجنب الأطعمة الصلبة واللزجة.',
      'الاستمرار على المطاط بين الفكين حسب الإرشاد.',
    ],
    doctorNotes: [
      'المريض ملتزم جيدًا بالخطة العلاجية.',
      'يفضّل الاستمرار باستخدام المطاط بين الفكين يوميًا.',
    ],
    attachmentsCount: 8,
    timeline: [
      TreatmentTimelineStepModel(
        title: 'الفحص والاستشارة',
        dateLabel: '12 مارس 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'الصور الشعاعية',
        dateLabel: '14 مارس 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'تركيب التقويم',
        dateLabel: '20 مارس 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'جلسة شد',
        dateLabel: '20 مايو 2026',
        subtitle: 'الساعة 05:00 م',
        state: TreatmentTimelineStepState.current,
      ),
      TreatmentTimelineStepModel(
        title: 'مراجعة شهرية',
        dateLabel: '17 يونيو 2026',
        state: TreatmentTimelineStepState.upcoming,
      ),
      TreatmentTimelineStepModel(
        title: 'مراجعة شهرية',
        dateLabel: '15 يوليو 2026',
        state: TreatmentTimelineStepState.upcoming,
      ),
    ],
    relatedAppointments: [
      TreatmentAppointmentModel(
        title: 'جلسة شد',
        dateLabel: '20 مايو 2026',
        timeLabel: '05:00 م',
        isUpcoming: true,
      ),
      TreatmentAppointmentModel(
        title: 'مراجعة شهرية',
        dateLabel: '17 يونيو 2026',
        timeLabel: '05:45 م',
        isUpcoming: true,
      ),
      TreatmentAppointmentModel(
        title: 'تركيب التقويم',
        dateLabel: '20 مارس 2026',
        timeLabel: '05:00 م',
        isUpcoming: false,
      ),
    ],
  ),
  TreatmentModel(
    id: 'tr-endo-02',
    name: 'علاج عصب السن 26',
    doctorName: 'د. سارة محمد',
    statusLabel: 'موعد قريب',
    status: TreatmentStatus.active,
    type: TreatmentType.rootCanal,
    completedSessions: 2,
    totalSessions: 3,
    progressPercent: 67,
    startedAtLabel: '5 مايو 2026',
    nextSessionLabel: '28 مايو 2026 - 04:30 م',
    summary:
        'استكمال علاج العصب مع إعادة بناء التاج المؤقت قبل الإغلاق النهائي.',
    completedProcedures: [
      'تشخيص الألم وأخذ صورة ذروية',
      'تنظيف القنوات وتعقيمها',
    ],
    careInstructions: [
      'تجنب المضغ على الجهة المعالجة حتى الجلسة القادمة.',
      'الالتزام بالمسكن الموصوف عند الحاجة.',
    ],
    doctorNotes: ['الاستجابة للعلاج ممتازة، لا توجد علامات التهاب حاد.'],
    attachmentsCount: 3,
    timeline: [
      TreatmentTimelineStepModel(
        title: 'تشخيص أولي',
        dateLabel: '5 مايو 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'تنظيف وتعقيم القنوات',
        dateLabel: '12 مايو 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'إغلاق نهائي',
        dateLabel: '28 مايو 2026',
        subtitle: 'الساعة 04:30 م',
        state: TreatmentTimelineStepState.current,
      ),
    ],
    relatedAppointments: [
      TreatmentAppointmentModel(
        title: 'إغلاق نهائي',
        dateLabel: '28 مايو 2026',
        timeLabel: '04:30 م',
        isUpcoming: true,
      ),
      TreatmentAppointmentModel(
        title: 'جلسة تنظيف القنوات',
        dateLabel: '12 مايو 2026',
        timeLabel: '04:00 م',
        isUpcoming: false,
      ),
    ],
  ),
  TreatmentModel(
    id: 'tr-white-03',
    name: 'تبييض الأسنان',
    doctorName: 'د. لؤي ياسين',
    statusLabel: 'مكتمل',
    status: TreatmentStatus.completed,
    type: TreatmentType.whitening,
    completedSessions: 1,
    totalSessions: 1,
    progressPercent: 100,
    startedAtLabel: '10 يناير 2026',
    nextSessionLabel: null,
    summary: 'جلسة تبييض احترافية داخل العيادة مع تعليمات عناية بعد الإجراء.',
    completedProcedures: ['جلسة تبييض احترافية', 'التقاط صور قبل وبعد'],
    careInstructions: [
      'تجنب المشروبات الملونة لمدة 48 ساعة.',
      'استخدم معجون الأسنان الخاص بالحساسية عند الحاجة.',
    ],
    doctorNotes: ['نتيجة ممتازة ودرجة التبييض مناسبة للون الطبيعي للأسنان.'],
    attachmentsCount: 4,
    timeline: [
      TreatmentTimelineStepModel(
        title: 'جلسة التبييض',
        dateLabel: '10 يناير 2026',
        state: TreatmentTimelineStepState.completed,
      ),
      TreatmentTimelineStepModel(
        title: 'صور بعد العلاج',
        dateLabel: '10 يناير 2026',
        state: TreatmentTimelineStepState.completed,
      ),
    ],
    relatedAppointments: [
      TreatmentAppointmentModel(
        title: 'جلسة التبييض',
        dateLabel: '10 يناير 2026',
        timeLabel: '06:00 م',
        isUpcoming: false,
      ),
    ],
  ),
];

const List<AttachmentModel> _attachments = [
  AttachmentModel(
    id: 'att-01',
    treatmentId: 'tr-ortho-01',
    title: 'أشعة بانوراما',
    dateLabel: '14 مارس 2026',
    category: AttachmentCategory.xray,
    type: AttachmentType.image,
    previewLabel: 'XR',
  ),
  AttachmentModel(
    id: 'att-02',
    treatmentId: 'tr-ortho-01',
    title: 'أشعة جانبية',
    dateLabel: '14 مارس 2026',
    category: AttachmentCategory.xray,
    type: AttachmentType.image,
    previewLabel: 'CEPH',
  ),
  AttachmentModel(
    id: 'att-03',
    treatmentId: 'tr-ortho-01',
    title: 'قبل التقويم',
    dateLabel: '20 مارس 2026',
    category: AttachmentCategory.images,
    type: AttachmentType.image,
    previewLabel: 'قبل',
  ),
  AttachmentModel(
    id: 'att-04',
    treatmentId: 'tr-ortho-01',
    title: 'بعد تركيب التقويم',
    dateLabel: '20 مارس 2026',
    category: AttachmentCategory.images,
    type: AttachmentType.image,
    previewLabel: 'بعد',
  ),
  AttachmentModel(
    id: 'att-05',
    treatmentId: 'tr-ortho-01',
    title: 'تقرير الخطة العلاجية',
    dateLabel: '18 مارس 2026',
    category: AttachmentCategory.reports,
    type: AttachmentType.pdf,
    previewLabel: 'PDF',
  ),
  AttachmentModel(
    id: 'att-06',
    treatmentId: 'tr-endo-02',
    title: 'صورة ذروية',
    dateLabel: '5 مايو 2026',
    category: AttachmentCategory.xray,
    type: AttachmentType.image,
    previewLabel: 'XR',
  ),
  AttachmentModel(
    id: 'att-07',
    treatmentId: 'tr-endo-02',
    title: 'تقرير علاج العصب',
    dateLabel: '12 مايو 2026',
    category: AttachmentCategory.reports,
    type: AttachmentType.pdf,
    previewLabel: 'PDF',
  ),
];

const List<PrescriptionModel> _prescriptions = [
  PrescriptionModel(
    id: 'pr-01',
    medicineName: 'مسكن ألم',
    concentration: 'Ibuprofen 400mg',
    dosage: 'حبة واحدة عند الحاجة',
    instructions: 'كل 8 ساعات عند الحاجة',
    duration: '5 أيام',
    prescribedAtLabel: '20 مايو 2026',
    doctorName: 'د. أحمد علي',
    status: PrescriptionStatus.active,
    notes:
        'تناول الدواء بعد الأكل، وفي حال استمرار الألم يرجى التواصل مع العيادة.',
    visualEmoji: '💊',
  ),
  PrescriptionModel(
    id: 'pr-02',
    medicineName: 'غسول فم',
    concentration: 'Chlorhexidine 0.12%',
    dosage: 'مرتين يوميًا',
    instructions: 'استخدمه بعد التفريش ولمدة 30 ثانية',
    duration: '7 أيام',
    prescribedAtLabel: '20 مايو 2026',
    doctorName: 'د. سارة محمد',
    status: PrescriptionStatus.active,
    notes: 'تجنب الأكل أو الشرب لمدة 30 دقيقة بعد الاستخدام.',
    visualEmoji: '🧴',
  ),
  PrescriptionModel(
    id: 'pr-03',
    medicineName: 'مضاد حيوي',
    concentration: 'Amoxicillin 500mg',
    dosage: 'كبسولة كل 8 ساعات',
    instructions: 'بعد الطعام',
    duration: '6 أيام',
    prescribedAtLabel: '14 مايو 2026',
    doctorName: 'د. لؤي ياسين',
    status: PrescriptionStatus.completed,
    notes: 'استكمل كامل المدة العلاجية حتى لو اختفت الأعراض.',
    visualEmoji: '💊',
  ),
];

const PaymentPlanModel _paymentPlan = PaymentPlanModel(
  id: 'pay-01',
  treatmentId: 'tr-ortho-01',
  treatmentName: 'تقويم الأسنان',
  doctorName: 'د. أحمد علي',
  totalCostLabel: '2,000,000 ل.س',
  paidAmountLabel: '1,500,000 ل.س',
  remainingAmountLabel: '500,000 ل.س',
  progressPercent: 75,
  expectedSessionsLabel: '18 - 24 جلسة',
  durationLabel: '18 - 24 شهر',
  records: [
    PaymentRecordModel(
      id: 'pay-rec-01',
      title: 'دفعة أولى',
      dateLabel: '20 مارس 2026',
      amountLabel: '1,000,000 ل.س',
      method: PaymentMethod.cash,
      isCompleted: true,
    ),
    PaymentRecordModel(
      id: 'pay-rec-02',
      title: 'دفعة ثانية',
      dateLabel: '10 مايو 2026',
      amountLabel: '500,000 ل.س',
      method: PaymentMethod.cash,
      isCompleted: true,
    ),
    PaymentRecordModel(
      id: 'pay-rec-03',
      title: 'دفعة ثالثة',
      dateLabel: '10 يونيو 2026',
      amountLabel: '500,000 ل.س',
      method: PaymentMethod.cash,
      isCompleted: false,
    ),
  ],
);
