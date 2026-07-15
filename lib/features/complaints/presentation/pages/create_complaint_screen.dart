import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../complaints_di.dart';
import '../../domain/entities/add_complaint_params.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/create_complaint/create_complaint_bloc.dart';
import '../bloc/create_complaint/create_complaint_event.dart';
import '../bloc/create_complaint/create_complaint_state.dart';
import '../widgets/complaint_form_field.dart';
import '../widgets/complaint_form_section_card.dart';

class CreateComplaintScreen extends StatelessWidget {
  const CreateComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateComplaintBloc(
        addComplaintUseCase: ComplaintsDi.addComplaintUseCase,
      ),
      child: const _CreateComplaintView(),
    );
  }
}

class _CreateComplaintView extends StatefulWidget {
  const _CreateComplaintView();

  @override
  State<_CreateComplaintView> createState() =>
      _CreateComplaintViewState();
}

class _CreateComplaintViewState extends State<_CreateComplaintView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;

  ComplaintPriority _selectedPriority =
      ComplaintPriority.medium;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  String get _languageCode {
    return Localizations.localeOf(context).languageCode;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final l10n = context.l10n;

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.complaintSubmitConfirmationTitle,
          ),
          content: Text(
            l10n.complaintSubmitConfirmationMessage,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                l10n.cancelComplaintSubmission,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                l10n.confirmComplaintSubmission,
              ),
            ),
          ],
        );
      },
    );

    if (shouldSubmit != true || !mounted) {
      return;
    }

    if (shouldSubmit != true || !mounted) {
      return;
    }

    final params = AddComplaintParams(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      priority: _selectedPriority,
    );

    context.read<CreateComplaintBloc>().add(
      SubmitComplaintRequested(
        params: params,
        languageCode: _languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocListener<CreateComplaintBloc, CreateComplaintState>(
      listener: (context, state) async {
        if (state.status == CreateComplaintStatus.failure) {
          await showErrorBottomSheet(
            context,
            title: l10n.complaintSubmitFailedTitle,
            message:
            state.errorMessage ?? l10n.unknownErrorMessage,
            buttonText: l10n.ok,
          );
        }

        if (state.status == CreateComplaintStatus.success &&
            state.createdComplaint != null) {
          final createdComplaint = state.createdComplaint!;

          await showSuccessBottomSheet(
            context,
            title: l10n.complaintSubmittedTitle,
            message: l10n.complaintSubmittedSuccessfully,
            buttonText: l10n.returnText,
            onPressed: () {
              context.pop(createdComplaint);
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
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  0,
                ),
                child: AppTopBar(
                  title: l10n.addComplaint,
                  showBackButton: true,
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      18,
                      20,
                      28,
                    ),
                    children: [
                      ComplaintFormSectionCard(
                        title: l10n.complaintBasicInformation,
                        subtitle:
                        l10n.complaintBasicInformationSubtitle,
                        child: Column(
                          children: [
                            ComplaintFormField(
                              label: l10n.complaintTitle,
                              hint: l10n.complaintTitleHint,
                              controller: _titleController,
                              validator: (value) {
                                final normalized =
                                    value?.trim() ?? '';

                                if (normalized.isEmpty) {
                                  return l10n
                                      .complaintTitleRequired;
                                }

                                if (normalized.length < 3) {
                                  return l10n
                                      .complaintTitleTooShort;
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: AppSpacing.md,
                            ),
                            ComplaintFormField(
                              label: l10n.complaintDescription,
                              hint:
                              l10n.complaintDescriptionHint,
                              controller:
                              _descriptionController,
                              maxLines: 5,
                              validator: (value) {
                                final normalized =
                                    value?.trim() ?? '';

                                if (normalized.isEmpty) {
                                  return l10n
                                      .complaintDescriptionRequired;
                                }

                                if (normalized.length < 10) {
                                  return l10n
                                      .complaintDescriptionTooShort;
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      ComplaintFormSectionCard(
                        title:
                        l10n.complaintContactInformation,
                        subtitle: l10n
                            .complaintContactInformationSubtitle,
                        child: ComplaintFormField(
                          label: l10n.complaintContactPhone,
                          hint: l10n.complaintPhoneHint,
                          controller: _phoneController,
                          validator: (value) {
                            final normalized =
                                value?.trim() ?? '';

                            if (normalized.isEmpty) {
                              return l10n
                                  .complaintPhoneRequired;
                            }

                            final phoneExpression = RegExp(
                              r'^[0-9+]{8,15}$',
                            );

                            if (!phoneExpression
                                .hasMatch(normalized)) {
                              return l10n.phoneInvalid;
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      ComplaintFormSectionCard(
                        title: l10n.complaintPriority,
                        subtitle: l10n
                            .complaintPrioritySectionSubtitle,
                        child: _ComplaintPrioritySelector(
                          selectedPriority:
                          _selectedPriority,
                          onChanged: (priority) {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          },
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
          minimum: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            18,
          ),
          child: BlocBuilder<
              CreateComplaintBloc,
              CreateComplaintState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                  state.isSubmitting ? null : _submit,
                  icon: state.isSubmitting
                      ? const SizedBox.shrink()
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    state.isSubmitting
                        ? l10n.submittingComplaint
                        : l10n.submitComplaint,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ComplaintPrioritySelector extends StatelessWidget {
  final ComplaintPriority selectedPriority;
  final ValueChanged<ComplaintPriority> onChanged;

  const _ComplaintPrioritySelector({
    required this.selectedPriority,
    required this.onChanged,
  });

  String _label(
      BuildContext context,
      ComplaintPriority priority,
      ) {
    final l10n = context.l10n;

    switch (priority) {
      case ComplaintPriority.low:
        return l10n.complaintPriorityLow;

      case ComplaintPriority.medium:
        return l10n.complaintPriorityMedium;

      case ComplaintPriority.high:
        return l10n.complaintPriorityHigh;

      case ComplaintPriority.unknown:
        return l10n.complaintPriorityUnknown;
    }
  }

  IconData _icon(ComplaintPriority priority) {
    switch (priority) {
      case ComplaintPriority.low:
        return Icons.keyboard_arrow_down_rounded;

      case ComplaintPriority.medium:
        return Icons.remove_rounded;

      case ComplaintPriority.high:
        return Icons.keyboard_arrow_up_rounded;

      case ComplaintPriority.unknown:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    const availablePriorities = [
      ComplaintPriority.low,
      ComplaintPriority.medium,
      ComplaintPriority.high,
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: availablePriorities.map((priority) {
        final isSelected =
            selectedPriority == priority;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppRadius.pill,
          ),
          child: InkWell(
            onTap: () => onChanged(priority),
            borderRadius: BorderRadius.circular(
              AppRadius.pill,
            ),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.navBarItem.withValues(
                  alpha: 0.13,
                )
                    : colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(
                  AppRadius.pill,
                ),
                border: Border.all(
                  color: isSelected
                      ? colors.navBarItem
                      : colors.borderSoft,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icon(priority),
                    size: 18,
                    color: isSelected
                        ? colors.navBarItem
                        : colors.textSecondary,
                  ),
                  const SizedBox(
                    width: AppSpacing.xs,
                  ),
                  Text(
                    _label(context, priority),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: isSelected
                          ? colors.navBarItem
                          : colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}