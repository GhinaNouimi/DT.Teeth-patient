import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/treatment_entity.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/medical_record_tab_bar.dart';
import '../widgets/treatment_card.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({super.key});

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  int _currentTabIndex = 0;
  List<TreatmentEntity> _treatments = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    final treatments = await MedicalRecordDi.getTreatmentsUseCase();
    if (!mounted) return;
    setState(() {
      _treatments = treatments;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeTreatments =
    _treatments.where((treatment) => treatment.isActive).toList();
    final completedTreatments =
    _treatments.where((treatment) => treatment.isCompleted).toList();
    final displayedTreatments =
    _currentTabIndex == 0 ? activeTreatments : completedTreatments;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'علاجاتي',
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  MedicalRecordTabBar(
                    labels: const ['الحالية', 'المكتملة'],
                    counts: [
                      activeTreatments.length,
                      completedTreatments.length,
                    ],
                    currentIndex: _currentTabIndex,
                    onChanged: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  if (displayedTreatments.isEmpty)
                    const MedicalRecordEmptyState(
                      title: 'لا توجد عناصر هنا بعد',
                      subtitle:
                      'بمجرد بدء خطة علاجية جديدة، ستظهر في هذا القسم.',
                      icon: Icons.medical_services_outlined,
                    )
                  else
                    ...displayedTreatments.map(
                          (treatment) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TreatmentCard(
                          treatment: treatment,
                          onTap: () {
                            context.push(
                              AppRoutes.medicalRecordTreatmentDetails,
                              extra: treatment.id,
                            );
                          },
                        ),
                      ),
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
