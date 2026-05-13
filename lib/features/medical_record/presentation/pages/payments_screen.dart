import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/payment_plan_entity.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/payment_progress_card.dart';
import '../widgets/payment_record_card.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentPlanEntity? _plan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final plan = await MedicalRecordDi.getPaymentPlanUseCase();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'الدفعات المالية',
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_plan == null)
                  ? const Padding(
                padding: EdgeInsets.all(20),
                child: MedicalRecordEmptyState(
                  title: 'لا توجد بيانات مالية حاليًا',
                  subtitle:
                  'ستظهر تفاصيل الخطة العلاجية والدفعات هنا.',
                  icon: Icons.wallet_rounded,
                ),
              )
                  : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  PaymentProgressCard(plan: _plan!),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.medicalRecordPaymentPlanDetails,
                      );
                    },
                    child: const Text('عرض تفاصيل الخطة'),
                  ),
                  const SizedBox(height: 10),
                  ..._plan!.records.map(
                        (record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PaymentRecordCard(record: record),
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
