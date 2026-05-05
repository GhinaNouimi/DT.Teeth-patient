import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../models/doctor_ui_model.dart';
import '../sections/doctors_header_section.dart';
import '../widgets/doctor_list_tile.dart';
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
      id: '1',
      name: 'د. سارة جابر',
      specialty: 'تقويم الأسنان',
      yearsOfExperience: 8,
      treatedPatients: 420,
      imageUrl: '👩‍⚕️',
      graduation: 'خريجة جامعة دمشق - كلية طب الأسنان - 2016',
      bio: 'متخصصة في تقويم الأسنان وتعمل على تصميم خطط علاجية دقيقة لتحسين الإطباق والمظهر الجمالي للأسنان.',
      phone: '+963 944 000 111',
      rating: 4.8,
      reviewsCount: 156,
      certificates: [
        'شهادة تقويم الأسنان من جامعة دمشق',
        'دورة متقدمة في التقويم الشفاف',
        'عضو في الجمعية السورية لتقويم الأسنان',
      ],
    ),
    DoctorUiModel(
      id: '2',
      name: 'د. محمد ياسين',
      specialty: 'زراعة الأسنان',
      yearsOfExperience: 11,
      treatedPatients: 610,
      imageUrl: '👨‍⚕️',
      graduation: 'خريج جامعة حلب - كلية طب الأسنان - 2013',
      bio: 'يمتلك خبرة واسعة في زراعة الأسنان والحلول التعويضية الحديثة مع اهتمام كبير براحة المريض وجودة النتائج.',
      phone: '+963 944 000 222',
      rating: 4.9,
      reviewsCount: 203,
      certificates: [
        'شهادة الزراعة من الجامعة الألمانية',
        'دبلوم في التصميم الرقمي للزراعات',
        'عضو في منظمة الزراعات العالمية',
      ],
    ),
    DoctorUiModel(
      id: '3',
      name: 'د. ريم الحسن',
      specialty: 'طب أسنان الأطفال',
      yearsOfExperience: 6,
      treatedPatients: 350,
      imageUrl: '👩‍⚕️',
      graduation: 'خريجة الجامعة السورية الخاصة - كلية طب الأسنان - 2018',
      bio: 'تهتم بعلاج الأطفال وتقديم تجربة علاجية مريحة وهادئة تساعد الطفل على بناء علاقة إيجابية مع طبيب الأسنان.',
      phone: '+963 944 000 333',
      rating: 4.7,
      reviewsCount: 128,
      certificates: [
        'شهادة طب أسنان الأطفال',
        'دورة في إدارة خوف الأطفال',
        'معتمدة من منظمة صحة الطفل',
      ],
    ),
  ];

  List<DoctorUiModel> get _filteredDoctors {
    return _doctors.where((doctor) {
      final matchesSpecialty =
          _selectedSpecialty == 'الكل' || doctor.specialty.contains(_selectedSpecialty);

      final query = _searchQuery.trim();
      final matchesSearch =
          query.isEmpty || doctor.name.contains(query) || doctor.specialty.contains(query);

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
              onChanged: (value) => setState(() => _searchQuery = value),
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
                    onTap: () => setState(() => _selectedSpecialty = specialty),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ..._filteredDoctors.map(
                  (doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DoctorListTile(
                  doctor: doctor,
                  onTap: () {
                    context.push(
                      AppRoutes.doctorDetails,  // ✅ هذا صحيح
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