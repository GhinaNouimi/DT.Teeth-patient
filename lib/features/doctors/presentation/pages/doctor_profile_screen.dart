import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../doctors_di.dart';
import '../../domain/entities/dentist_details_entity.dart';
import '../bloc/dentist_details/dentist_details_bloc.dart';
import '../bloc/dentist_details/dentist_details_event.dart';
import '../bloc/dentist_details/dentist_details_state.dart';
import '../bloc/dentist_rate/dentist_rate_bloc.dart';
import '../bloc/dentist_rate/dentist_rate_event.dart';
import '../bloc/dentist_rate/dentist_rate_state.dart';
import '../sections/doctor_about_section.dart';
import '../sections/doctor_info_cards_section.dart';
import '../sections/doctor_profile_header_section.dart';
import '../sections/doctor_ratings_section.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int dentistId;

  const DoctorProfileScreen({
    super.key,
    required this.dentistId,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _userRating = 0;
  int _currentRate = 0;
  bool _isSubmittingRate = false;

  void _updateRating(int rating) {
    setState(() => _userRating = rating);
  }

  void _resetRating() {
    setState(() => _userRating = 0);
  }

  void _submitRating(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    context.read<DentistRateBloc>().add(
      AddDentistRateRequested(
        dentistId: widget.dentistId,
        rating: _userRating,
        languageCode: languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DentistDetailsBloc(
            showDentistDetailsUseCase:
            DoctorsDi.showDentistDetailsUseCase,
          )..add(
            ShowDentistDetailsRequested(
              dentistId: widget.dentistId,
              languageCode: languageCode,
            ),
          ),
        ),
        BlocProvider(
          create: (_) => DentistRateBloc(
            showDentistRateUseCase: DoctorsDi.showDentistRateUseCase,
            addDentistRateUseCase: DoctorsDi.addDentistRateUseCase,
          )..add(
            ShowDentistRateRequested(
              dentistId: widget.dentistId,
              languageCode: languageCode,
            ),
          ),
        ),
      ],
      child: BlocListener<DentistRateBloc, DentistRateState>(
        listener: (context, state) {
          final l10n = context.l10n;

          if (state is DentistRateLoaded) {
            setState(() {
              _currentRate = state.rating;
              _userRating = 0;
            });
          }

          if (state is DentistRateSubmitting) {
            setState(() {
              _isSubmittingRate = true;
            });
          }

          if (state is DentistRateSubmitted) {
            setState(() {
              _isSubmittingRate = false;
              _currentRate = state.averageRating;
            });

            showSuccessBottomSheet(
              context,
              title: l10n.savedSuccessfully,
              message: l10n.ratingSubmittedSuccessfully,
              buttonText: l10n.ok,
              onPressed: _resetRating,
            );
          }

          if (state is DentistRateFailure) {
            setState(() {
              _isSubmittingRate = false;
            });

            showErrorBottomSheet(
              context,
              title: l10n.genericErrorTitle,
              message: state.message,
              buttonText: l10n.ok,
            );
          }
        },
        child: _DoctorProfileView(
          currentRate: _currentRate,
          userRating: _userRating,
          isSubmittingRate: _isSubmittingRate,
          onRatingChanged: _updateRating,
          onSubmitRating: _submitRating,
        ),
      ),
    );
  }
}

class _DoctorProfileView extends StatelessWidget {
  final int currentRate;
  final int userRating;
  final bool isSubmittingRate;
  final ValueChanged<int> onRatingChanged;
  final void Function(BuildContext context) onSubmitRating;

  const _DoctorProfileView({
    required this.currentRate,
    required this.userRating,
    required this.isSubmittingRate,
    required this.onRatingChanged,
    required this.onSubmitRating,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<DentistDetailsBloc, DentistDetailsState>(
          builder: (context, state) {
            if (state is DentistDetailsLoading ||
                state is DentistDetailsInitial) {
              return AppSkeleton(
                enabled: true,
                child: _DoctorDetailsContent(
                  dentist: _skeletonDentistDetails,
                  isFromCache: false,
                  currentRate: 0,
                  userRating: 0,
                  isSubmittingRate: false,
                  onRatingChanged: (_) {},
                  onSubmitRating: () {},
                ),
              );
            }

            if (state is DentistDetailsFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textPrimary),
                  ),
                ),
              );
            }

            if (state is DentistDetailsLoaded) {
              return _DoctorDetailsContent(
                dentist: state.dentist.data,
                isFromCache: state.dentist.isFromCache,
                currentRate: currentRate,
                userRating: userRating,
                isSubmittingRate: isSubmittingRate,
                onRatingChanged: onRatingChanged,
                onSubmitRating: () => onSubmitRating(context),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _DoctorDetailsContent extends StatelessWidget {
  final DentistDetailsEntity dentist;
  final bool isFromCache;
  final int currentRate;
  final int userRating;
  final bool isSubmittingRate;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmitRating;

  const _DoctorDetailsContent({
    required this.dentist,
    required this.isFromCache,
    required this.currentRate,
    required this.userRating,
    required this.isSubmittingRate,
    required this.onRatingChanged,
    required this.onSubmitRating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        AppTopBar(
          title: l10n.doctorProfile,
          onBackTap: () => context.pop(),
        ),
        const SizedBox(height: 16),
        if (isFromCache) ...[
          OfflineCachedBanner(
            message: l10n.offlineCachedDataMessage,
          ),
          const SizedBox(height: 16),
        ],
        DoctorProfileHeaderSection(
          dentist: dentist,
          languageCode: languageCode,
        ),
        const SizedBox(height: 24),
        DoctorAboutSection(
          bio: dentist.bio,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 24),
        DoctorInfoCardsSection(
          yearsOfExperience: dentist.yearsOfExperience,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 20),
        DoctorRatingsSection(
          currentRating: currentRate,
          userRating: userRating,
          isSubmitting: isSubmittingRate,
          onRatingChanged: onRatingChanged,
          onSubmitRating: onSubmitRating,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

const DentistDetailsEntity _skeletonDentistDetails = DentistDetailsEntity(
  id: 0,
  name: 'Dentist Name',
  profilePicture: null,
  specializationAr: 'التخصص',
  specializationEn: 'Specialization',
  yearsOfExperience: 10,
  averageRating: '4.0',
  bio: 'Dentist bio preview text.',
);