import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_filter_tabs.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../doctors_di.dart';
import '../../domain/entities/dentist_entity.dart';
import '../bloc/doctors/doctors_bloc.dart';
import '../bloc/doctors/doctors_event.dart';
import '../bloc/doctors/doctors_state.dart';
import '../widgets/doctor_card_widget.dart';
import '../widgets/doctor_search_field.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedSpecialty = '';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DentistEntity> _filterDentists({
    required List<DentistEntity> dentists,
    required String languageCode,
  }) {
    return dentists.where((dentist) {
      final specialization = languageCode == 'en'
          ? dentist.specializationNameEn
          : dentist.specializationName;

      final matchesSearch =
          dentist.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              specialization.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

      final matchesSpecialty =
          _selectedSpecialty.isEmpty || specialization == _selectedSpecialty;

      return matchesSearch && matchesSpecialty;
    }).toList();
  }

  List<String> _getSpecialties({
    required List<DentistEntity> dentists,
    required String languageCode,
  }) {
    return dentists
        .map(
          (dentist) => languageCode == 'en'
          ? dentist.specializationNameEn
          : dentist.specializationName,
    )
        .where((specialty) => specialty.trim().isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => DoctorsBloc(
        showAllDentistsUseCase: DoctorsDi.showAllDentistsUseCase,
        showDentistsBySpecializationUseCase:
        DoctorsDi.showDentistsBySpecializationUseCase,
      )..add(
        ShowAllDentistsRequested(
          languageCode: languageCode,
        ),
      ),
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: BlocBuilder<DoctorsBloc, DoctorsState>(
            builder: (context, state) {
              if (state is DoctorsLoading || state is DoctorsInitial) {
                return AppSkeleton(
                  enabled: true,
                  child: _DoctorsContent(
                    dentists: _skeletonDentists,
                    specialties: const [],
                    selectedSpecialty: '',
                    searchController: _searchController,
                    languageCode: languageCode,
                    showOfflineBanner: false,
                    onSearchChanged: (_) {},
                    onSpecialtyChanged: (_) {},
                  ),
                );
              }

              if (state is DoctorsFailure) {
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

              if (state is DoctorsLoaded) {
                final allDentists = state.dentists.data;
                final specialties = _getSpecialties(
                  dentists: allDentists,
                  languageCode: languageCode,
                );

                final filteredDentists = _filterDentists(
                  dentists: allDentists,
                  languageCode: languageCode,
                );

                return _DoctorsContent(
                  dentists: filteredDentists,
                  specialties: specialties,
                  selectedSpecialty: _selectedSpecialty,
                  searchController: _searchController,
                  languageCode: languageCode,
                  showOfflineBanner: state.dentists.isFromCache,
                  onSearchChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onSpecialtyChanged: (specialty) {
                    setState(() {
                      _selectedSpecialty = specialty;
                    });
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _DoctorsContent extends StatelessWidget {
  final List<DentistEntity> dentists;
  final List<String> specialties;
  final String selectedSpecialty;
  final TextEditingController searchController;
  final String languageCode;
  final bool showOfflineBanner;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSpecialtyChanged;

  const _DoctorsContent({
    required this.dentists,
    required this.specialties,
    required this.selectedSpecialty,
    required this.searchController,
    required this.languageCode,
    required this.showOfflineBanner,
    required this.onSearchChanged,
    required this.onSpecialtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              if (showOfflineBanner) ...[
                OfflineCachedBanner(
                  message: l10n.offlineCachedDataMessage,
                ),
                const SizedBox(height: 12),
              ],
              DoctorSearchFieldWidget(
                controller: searchController,
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 16),
              AppFilterTabs<String>(
                selectedValue: selectedSpecialty,
                onChanged: onSpecialtyChanged,
                items: [
                  AppFilterTabItem<String>(
                    value: '',
                    label: l10n.allDentists,
                  ),
                  ...specialties.map(
                        (specialty) => AppFilterTabItem<String>(
                      value: specialty,
                      label: specialty,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: dentists.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.noDoctorsSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            physics: const BouncingScrollPhysics(),
            itemCount: dentists.length,
            itemBuilder: (context, index) {
              final dentist = dentists[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DoctorCardWidget(
                  dentist: dentist,
                  languageCode: languageCode,
                  onTap: () {
                    context.push(
                      AppRoutes.doctorDetails,
                      extra: dentist.id,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const List<DentistEntity> _skeletonDentists = [
  DentistEntity(
    id: 0,
    userId: 0,
    name: 'Dentist Name',
    email: '',
    phone: '',
    role: 2,
    specializationName: 'Specialization',
    specializationNameEn: 'Specialization',
    profilePicture: null,
  ),
  DentistEntity(
    id: 1,
    userId: 0,
    name: 'Dentist Name',
    email: '',
    phone: '',
    role: 2,
    specializationName: 'Specialization',
    specializationNameEn: 'Specialization',
    profilePicture: null,
  ),
  DentistEntity(
    id: 2,
    userId: 0,
    name: 'Dentist Name',
    email: '',
    phone: '',
    role: 2,
    specializationName: 'Specialization',
    specializationNameEn: 'Specialization',
    profilePicture: null,
  ),
];