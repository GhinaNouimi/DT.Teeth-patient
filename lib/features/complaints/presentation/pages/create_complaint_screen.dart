import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../complaints_di.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/create_complaint/create_complaint_bloc.dart';
import '../bloc/create_complaint/create_complaint_event.dart';
import '../bloc/create_complaint/create_complaint_state.dart';
import '../widgets/complaint_attachment_card.dart';
import '../widgets/complaint_category_selector.dart';
import '../widgets/complaint_form_field.dart';
import '../widgets/complaint_form_section_card.dart';

class CreateComplaintScreen extends StatelessWidget {
  const CreateComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateComplaintBloc(
        submitComplaintUseCase: ComplaintsDi.submitComplaintUseCase,
      ),
      child: const _CreateComplaintView(),
    );
  }
}

class _CreateComplaintView extends StatefulWidget {
  const _CreateComplaintView();

  @override
  State<_CreateComplaintView> createState() => _CreateComplaintViewState();
}

class _CreateComplaintViewState extends State<_CreateComplaintView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _relatedReferenceController;

  ComplaintCategory _selectedCategory = ComplaintCategory.appointment;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _relatedReferenceController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _relatedReferenceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد الإرسال'),
          content: const Text(
            'هل تريد إرسال هذه الشكوى الآن؟ يمكنك متابعة حالتها لاحقًا من قسم الشكاوى.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );

    if (shouldSubmit != true || !mounted) return;

    final complaint = ComplaintEntity(
      id: 'C-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,

      /// أول حالة بعد إنشاء الشكوى:
      /// تعني أن الشكوى وصلت للنظام وتم تسجيلها.
      status: ComplaintStatus.open,

      createdAt: DateTime.now(),
      relatedReference: _relatedReferenceController.text.trim().isEmpty
          ? null
          : _relatedReferenceController.text.trim(),
      attachments: const [],
      updates: const [],
    );

    context.read<CreateComplaintBloc>().add(
      SubmitComplaintRequested(complaint),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<CreateComplaintBloc, CreateComplaintState>(
      listener: (context, state) async {
        if (state.status == CreateComplaintStatus.failure) {
          await showErrorBottomSheet(
            context,
            title: 'تعذر إرسال الشكوى',
            message: state.errorMessage ?? 'حدث خطأ غير متوقع',
            buttonText: 'حسنًا',
          );
        }

        if (state.status == CreateComplaintStatus.success) {
          await showSuccessBottomSheet(
            context,
            title: 'تم استلام الشكوى',
            message:
            'استلمنا شكواك بنجاح، ويمكنك متابعة حالتها من قسم الشكاوى.',
            buttonText: 'العودة للشكاوى',
            onPressed: () {
              context.pop(true);
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: AppTopBar(
                  title: 'تقديم شكوى',
                  showBackButton: true,
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    children: [
                      ComplaintFormSectionCard(
                        title: 'نوع الشكوى',
                        subtitle:
                        'اختر القسم الأقرب لمشكلتك حتى تصل الشكوى للفريق المناسب.',
                        child: ComplaintCategorySelector(
                          selectedCategory: _selectedCategory,
                          onChanged: (value) {
                            setState(() => _selectedCategory = value);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ComplaintFormSectionCard(
                        title: 'تفاصيل الشكوى',
                        child: Column(
                          children: [
                            ComplaintFormField(
                              label: 'عنوان الشكوى',
                              hint: 'مثال: تأخر في موعد المتابعة',
                              controller: _titleController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'الرجاء إدخال عنوان الشكوى';
                                }
                                if (value.trim().length < 6) {
                                  return 'عنوان الشكوى قصير جدًا';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ComplaintFormField(
                              label: 'وصف الشكوى',
                              hint:
                              'اكتب وصفًا واضحًا للمشكلة أو الاستفسار...',
                              controller: _descriptionController,
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'الرجاء إدخال وصف الشكوى';
                                }
                                if (value.trim().length < 12) {
                                  return 'يرجى إضافة تفاصيل أكثر';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ComplaintFormField(
                              label: 'مرجع مرتبط (اختياري)',
                              hint: 'رقم موعد أو علاج أو دفعة',
                              controller: _relatedReferenceController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ComplaintFormSectionCard(
                        title: 'مرفقات',
                        subtitle: 'سيتم تفعيلها لاحقًا',
                        child: ComplaintAttachmentCard(
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          child: BlocBuilder<CreateComplaintBloc, CreateComplaintState>(
            builder: (context, state) {
              final isSubmitting =
                  state.status == CreateComplaintStatus.submitting;

              return ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                child: Text(
                  isSubmitting ? 'جارٍ إرسال الشكوى...' : 'إرسال الشكوى',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}