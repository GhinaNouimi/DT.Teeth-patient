import '../models/profile_model.dart';

class ProfileMockDataSource {
  ProfileModel _profile = const ProfileModel(
    id: 'profile-001',
    name: 'نور الهدى أحمد',
    email: 'noor.ahmad@example.com',
    phone: '+963 944 123 456',
    dateOfBirth: '14 يونيو 1998',
    gender: 0,
    address: 'دمشق - المزة',
    emergencyContactName: 'أحمد خالد',
    emergencyContactRelation: 'الأب',
    emergencyContactPhone: '+963 933 000 111',
    isPregnant: false,
    isBreastfeeding: false,
    isSmoker: false,
    drinksAlcoholFrequently: false,
    teethCleaningFrequency: 'مرتان يوميًا',
    avatarStyleId: 'female_1',
    isDarkModeEnabled: false,
    languageCode: 'ar',
  );

  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _profile;
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    _profile = profile;
    return _profile;
  }
}