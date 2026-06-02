import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../medical_record_di.dart';
import '../../domain/entities/payment_plan_entity.dart';
import '../widgets/medical_record_empty_state.dart';
import '../widgets/payment_record_card.dart';

class PaymentPlanDetailsScreen extends StatefulWidget {
  const PaymentPlanDetailsScreen({super.key});

  @override
  State<PaymentPlanDetailsScreen> createState() =>
      _PaymentPlanDetailsScreenState();
}

class _PaymentPlanDetailsScreenState extends State<PaymentPlanDetailsScreen> {
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
    final theme = Theme.of(context);

    Widget detailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(title: 'تفاصيل الخطة'),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_plan == null)
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: MedicalRecordEmptyState(
                        title: 'تعذر تحميل الخطة',
                        subtitle: 'يرجى المحاولة لاحقًا.',
                        icon: Icons.wallet_rounded,
                      ),
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colors.surfaceMuted,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: colors.borderSoft),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _plan!.treatmentName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _plan!.doctorName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colors.surfacePrimary,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: colors.borderSoft),
                          ),
                          child: Column(
                            children: [
                              detailRow(
                                'إجمالي التكلفة',
                                _plan!.totalCostLabel,
                              ),
                              const Divider(height: 1),
                              detailRow(
                                'عدد الجلسات',
                                _plan!.expectedSessionsLabel,
                              ),
                              const Divider(height: 1),
                              detailRow('مدة الخطة', _plan!.durationLabel),
                              const Divider(height: 1),
                              detailRow('المتبقي', _plan!.remainingAmountLabel),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
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
