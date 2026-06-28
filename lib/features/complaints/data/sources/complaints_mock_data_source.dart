import '../models/complaint_model.dart';

class ComplaintsMockDataSource {
  final List<ComplaintModel> _complaints = [
    ComplaintModel(
      id: 'C-2026-003',
      title: 'تم حل مشكلة موعد المتابعة',
      description: 'تم تأجيل موعد المتابعة السابق ولم أكن أعلم سبب التغيير.',
      category: 'appointment',
      status: 'resolved',
      createdAt: DateTime(2026, 6, 16),
      relatedReference: 'APT-184',
      attachments: const [],
      updates: const [],
      centerReply:
      'نعتذر عن الإزعاج. تم التأكد من سبب التأجيل، وكان بسبب ظرف طارئ في جدول الطبيب. تم تثبيت موعد بديل مناسب ولن يتم احتساب أي رسوم إضافية.',
      resolvedAt: DateTime(2026, 6, 18, 13, 20),
    ),
    ComplaintModel(
      id: 'C-2026-001',
      title: 'تأخير في موعد المتابعة',
      description: 'تم تأجيل الموعد أكثر من مرة وأرغب بمعرفة السبب.',
      category: 'appointment',
      status: 'inProgress',
      createdAt: DateTime(2026, 6, 20),
      relatedReference: 'APT-203',
      attachments: const [],
      updates: const [],
    ),
    ComplaintModel(
      id: 'C-2026-002',
      title: 'استفسار حول دفعة مالية',
      description: 'أحتاج توضيحًا حول مبلغ مضاف في الخطة العلاجية.',
      category: 'payment',
      status: 'open',
      createdAt: DateTime(2026, 6, 18),
      relatedReference: 'PAY-88',
      attachments: const [],
      updates: const [],
    ),
  ];

  Future<List<ComplaintModel>> getComplaints() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<ComplaintModel>.from(_complaints);
  }

  Future<ComplaintModel> getComplaintDetails(String complaintId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _complaints.firstWhere((item) => item.id == complaintId);
  }

  Future<ComplaintModel> submitComplaint(ComplaintModel complaint) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    _complaints.insert(0, complaint);
    return complaint;
  }
}