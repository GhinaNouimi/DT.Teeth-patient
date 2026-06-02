import 'package:dt_teeth/features/doctors/presentation/models/doctor_ui_model.dart';

class MockDoctorsData {
  static final List<DoctorUiModel> doctors = const [
    DoctorUiModel(
      id: '1',
      name: 'د. سارة جابر',
      specialty: 'تقويم الأسنان',
      yearsOfExperience: 8,
      treatedPatients: 420,
      imageUrl: '👩‍⚕️',
      graduation: 'خريجة جامعة دمشق - كلية طب الأسنان - 2016',
      bio:
          'متخصصة في تقويم الأسنان وتعمل على تصميم خطط علاجية دقيقة لتحسين الإطباق والمظهر الجمالي للأسنان.',
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
      bio:
          'يمتلك خبرة واسعة في زراعة الأسنان والحلول التعويضية الحديثة مع اهتمام كبير براحة المريض وجودة النتائج.',
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
      bio:
          'تهتم بعلاج الأطفال وتقديم تجربة علاجية مريحة وهادئة تساعد الطفل على بناء علاقة إيجابية مع طبيب الأسنان.',
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

  static List<DoctorUiModel> filterBySpecialty(String specialty) {
    if (specialty == 'الكل' || specialty.isEmpty) {
      return doctors;
    }
    return doctors
        .where((doctor) => doctor.specialty.contains(specialty))
        .toList();
  }

  static List<DoctorUiModel> search(String query) {
    if (query.isEmpty) {
      return doctors;
    }
    final lowerQuery = query.toLowerCase();
    return doctors
        .where(
          (doctor) =>
              doctor.name.toLowerCase().contains(lowerQuery) ||
              doctor.specialty.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  static List<String> getUniqueSpecialties() {
    final specialties = {'الكل'};
    for (var doctor in doctors) {
      specialties.add(doctor.specialty);
    }
    return specialties.toList();
  }
}
