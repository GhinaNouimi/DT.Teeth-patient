import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/doctor_ui_model.dart';
import '../sections/doctors_header_section.dart';
import '../widgets/doctor_list_item.dart';
import '../widgets/doctor_search_field.dart';
import '../widgets/specialty_filter_chip.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _specialties = const [
    'الكل',
    'تقويم',
    'زراعة',
    'أطفال',
    'تجميل',
    'تنظيف',
  ];

  String _selectedSpecialty = 'الكل';
  String _searchQuery = '';

  final List<DoctorUiModel> _doctors = const [
    DoctorUiModel(
      name: 'د. سارة جابر',
      specialty: 'تقويم الأسنان',
      yearsOfExperience: 8,
      treatedPatients: 420,
      imageUrl: '',
      graduation: 'خريجة جامعة دمشق - كلية طب الأسنان',
      bio: 'متخصصة في تقويم الأسنان وتعمل على تصميم خطط علاجية دقيقة لتحسين الإطباق والمظهر الجمالي للأسنان.',
      phone: '+963 944 000 111',
      email: 'sara.jaber@dtteeth.com',
      instagram: '@dr.sara.jaber',
      linkedin: 'linkedin.com/in/dr-sara-jaber',
    ),
    DoctorUiModel(
      name: 'د. محمد ياسين',
      specialty: 'زراعة الأسنان',
      yearsOfExperience: 11,
      treatedPatients: 610,
      imageUrl: '',
      graduation: 'خريج جامعة حلب - كلية طب الأسنان',
      bio: 'يمتلك خبرة واسعة في زراعة الأسنان والحلول التعويضية الحديثة مع اهتمام كبير براحة المريض وجودة النتائج.',
      phone: '+963 944 000 222',
      email: 'mohammad.yaseen@dtteeth.com',
      instagram: '@dr.mohammad.yaseen',
      linkedin: 'linkedin.com/in/dr-mohammad-yaseen',
    ),
    DoctorUiModel(
      name: 'د. ريم الحسن',
      specialty: 'طب أسنان الأطفال',
      yearsOfExperience: 6,
      treatedPatients: 350,
      imageUrl: '',
      graduation: 'خريجة الجامعة السورية الخاصة - كلية طب الأسنان',
      bio: 'تهتم بعلاج الأطفال وتقديم تجربة علاجية مريحة وهادئة تساعد الطفل على بناء علاقة إيجابية مع طبيب الأسنان.',
      phone: '+963 944 000 333',
      email: 'reem.alhassan@dtteeth.com',
      instagram: '@dr.reem.alhassan',
      linkedin: 'linkedin.com/in/dr-reem-alhassan',
    ),
  ];

  List<DoctorUiModel> get _filteredDoctors {
    return _doctors.where((doctor) {
      final matchesSpecialty = _selectedSpecialty == 'الكل' ||
          doctor.specialty.contains(_selectedSpecialty);

      final query = _searchQuery.trim();
      final matchesSearch = query.isEmpty ||
          doctor.name.contains(query) ||
          doctor.specialty.contains(query);

      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const DoctorsHeaderSection(),
            const SizedBox(height: 18),
            DoctorSearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _specialties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final specialty = _specialties[index];
                  return SpecialtyFilterChip(
                    label: specialty,
                    selected: _selectedSpecialty == specialty,
                    onTap: () {
                      setState(() => _selectedSpecialty = specialty);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ..._filteredDoctors.map(
                  (doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DoctorListItem(
                  doctor: doctor,
                  onViewProfile: () {
                    context.push(
                      AppRoutes.doctorProfile,
                      extra: doctor,
                    );
                  },
                  onBookAppointment: () {
                    context.push(
                      AppRoutes.bookDoctorAppointment,
                      extra: doctor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
