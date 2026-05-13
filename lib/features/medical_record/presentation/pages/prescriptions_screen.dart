import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/prescription_entity.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/medical_record_tab_bar.dart';
import '../widgets/prescription_card.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  int _currentTabIndex = 0;
  List<PrescriptionEntity> _prescriptions = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final prescriptions = await MedicalRecordDi.getPrescriptionsUseCase();
    if (!mounted) return;
    setState(() {
      _prescriptions = prescriptions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = _prescriptions.where((item) => item.isActive).toList();
    final previous = _prescriptions.where((item) => !item.isActive).toList();
    final displayed = _currentTabIndex == 0 ? active : previous;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'الوصفات الطبية',
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
                    labels: const ['الحالية', 'السابقة'],
                    counts: [
                      active.length,
                      previous.length,
                    ],
                    currentIndex: _currentTabIndex,
                    onChanged: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  if (displayed.isEmpty)
                    const MedicalRecordEmptyState(
                      title: 'لا توجد وصفات هنا',
                      subtitle:
                      'ستظهر الوصفات الحالية والسابقة في هذا القسم.',
                      icon: Icons.receipt_long_rounded,
                    )
                  else
                    ...displayed.map(
                          (prescription) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: PrescriptionCard(
                          prescription: prescription,
                          onTap: () {
                            context.push(
                              AppRoutes.medicalRecordPrescriptionDetails,
                              extra: prescription.id,
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
