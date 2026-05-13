import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/attachment_entity.dart';
import '../widgets/attachment_card.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/medical_record_tab_bar.dart';

class AttachmentsScreen extends StatefulWidget {
  final String treatmentId;

  const AttachmentsScreen({
    super.key,
    required this.treatmentId,
  });

  @override
  State<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends State<AttachmentsScreen> {
  int _currentTabIndex = 0;
  List<AttachmentEntity> _attachments = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    final attachments = await MedicalRecordDi.getAttachmentsByTreatmentUseCase(
      widget.treatmentId,
    );
    if (!mounted) return;
    setState(() {
      _attachments = attachments;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filtered = _attachments.where((attachment) {
      switch (_currentTabIndex) {
        case 0:
          return attachment.category == AttachmentCategory.images;
        case 1:
          return attachment.category == AttachmentCategory.xray;
        default:
          return attachment.category == AttachmentCategory.reports;
      }
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: 'الملفات والمرفقات'),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  MedicalRecordTabBar(
                    labels: const ['الصور', 'الأشعة', 'التقارير'],
                    counts: [
                      _attachments
                          .where((e) => e.category == AttachmentCategory.images)
                          .length,
                      _attachments
                          .where((e) => e.category == AttachmentCategory.xray)
                          .length,
                      _attachments
                          .where((e) => e.category == AttachmentCategory.reports)
                          .length,
                    ],
                    currentIndex: _currentTabIndex,
                    onChanged: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  if (filtered.isEmpty)
                    const MedicalRecordEmptyState(
                      title: 'لا توجد ملفات ضمن هذا القسم',
                      subtitle:
                      'ستظهر الصور والتقارير هنا فور إضافتها للملف الطبي.',
                      icon: Icons.folder_open_rounded,
                    )
                  else
                    GridView.builder(
                      itemCount: filtered.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        return AttachmentCard(
                          attachment: filtered[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
