import 'package:dt_teeth/features/doctors/presentation/models/doctor_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_filter_tabs.dart';
import '../data/mock_doctors_data.dart';
import '../widgets/doctor_card_widget.dart';
import '../widgets/doctor_search_field.dart';

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

  final List<DoctorUiModel> _doctors = [];

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
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400));

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
      if (isRefresh) {
        _doctors.clear();
      }
      _hasMore = false;
      setState(() => _isLoading = false);
      return;
    }

    final newDoctors = allDoctors.sublist(
      start,
      end > allDoctors.length ? allDoctors.length : end,
    );

    if (isRefresh) {
      _doctors
        ..clear()
        ..addAll(newDoctors);
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  DoctorSearchFieldWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _resetAndFetch();
                    },
                  ),
                  const SizedBox(height: 16),
                  AppFilterTabs<String>(
                    selectedValue: _selectedSpecialty,
                    onChanged: (specialty) {
                      setState(() => _selectedSpecialty = specialty);
                      _resetAndFetch();
                    },
                    items: specialties
                        .map(
                          (specialty) => AppFilterTabItem<String>(
                        value: specialty,
                        label: specialty,
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
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