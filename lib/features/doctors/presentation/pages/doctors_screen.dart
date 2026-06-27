import 'package:dt_teeth/features/doctors/presentation/models/doctor_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../data/mock_doctors_data.dart';
import '../sections/doctors_header_section.dart';
import '../widgets/doctor_card_widget.dart';
import '../widgets/doctor_search_field.dart';
import '../widgets/specialty_filter_chip.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedSpecialty = 'الكل';
  String _searchQuery = '';

  List<DoctorUiModel> _doctors = [];

  int _page = 1;
  final int _limit = 10;

  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchDoctors();
      }
    });
  }

  Future<void> _fetchDoctors({bool isRefresh = false}) async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400)); // simulate API

    final allDoctors = MockDoctorsData.filterBySpecialty(_selectedSpecialty)
        .where(
          (doctor) =>
              doctor.name.contains(_searchQuery) ||
              doctor.specialty.contains(_searchQuery),
        )
        .toList();

    final start = (_page - 1) * _limit;
    final end = start + _limit;

    if (start >= allDoctors.length) {
      _hasMore = false;
      setState(() => _isLoading = false);
      return;
    }

    final newDoctors = allDoctors.sublist(
      start,
      end > allDoctors.length ? allDoctors.length : end,
    );

    if (isRefresh) {
      _doctors = newDoctors;
    } else {
      _doctors.addAll(newDoctors);
    }

    if (newDoctors.length < _limit) {
      _hasMore = false;
    } else {
      _page++;
    }

    setState(() => _isLoading = false);
  }

  void _resetAndFetch() {
    _page = 1;
    _hasMore = true;
    _doctors.clear();
    _fetchDoctors(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final specialties = MockDoctorsData.getUniqueSpecialties();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header + Search + Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const DoctorsHeaderSection(),
                  const SizedBox(height: 18),

                  DoctorSearchFieldWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _resetAndFetch();
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: specialties.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final specialty = specialties[index];

                        return SpecialtyFilterWidget(
                          label: specialty,
                          selected: _selectedSpecialty == specialty,
                          onTap: () {
                            setState(() => _selectedSpecialty = specialty);
                            _resetAndFetch();
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            /// 🔹 قائمة الأطباء (Pagination)
            Expanded(
              child: _doctors.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: _doctors.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _doctors.length) {
                          final doctor = _doctors[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: DoctorCardWidget(
                              doctor: doctor,
                              onTap: () {
                                context.push(
                                  AppRoutes.doctorDetails,
                                  extra: doctor,
                                );
                              },
                            ),
                          );
                        }

                        /// 🔹 Loader أسفل القائمة
                        return _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
