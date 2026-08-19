import 'package:dt_teeth/features/profile/data/models/profile_model.dart';
import 'package:dt_teeth/features/profile/data/models/update_profile_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> apiProfileJson() => <String, dynamic>{
  'data': <String, dynamic>{
    'id': 12,
    'user_id': '40',
    'user': <String, dynamic>{
      'name': 'Ghina',
      'email': 'ghina@example.com',
      'phone': '0999999999',
      'date_of_birth': '2000-01-02',
      'gender': '2',
      'address': 'Damascus',
      'profile_picture': 'profile.jpg',
    },
    'emergency_contact_name': 'Rama',
    'emergency_contact_relation': 'Sister',
    'emergency_contact_phone': '0988888888',
    'is_pregnant': 0,
    'is_breastfeeding': 'false',
    'is_smoker': '1',
    'drinks_alcohol_frequently': true,
    'teeth_cleaning_frequency': 'twice_daily',
    'allergies': <dynamic>['Penicillin', 7],
    'chronic_diseases': <String>['Diabetes'],
    'medications': <String>['Medicine A'],
  },
};

void main() {
  group('ProfileModel', () {
    test(
      'UT-MOD-PRO-01 parses nested API response and mixed primitive types',
      () {
        final model = ProfileModel.fromApiJson(apiProfileJson());

        expect(model.id, '12');
        expect(model.userId, '40');
        expect(model.name, 'Ghina');
        expect(model.gender, 2);
        expect(model.isPregnant, isFalse);
        expect(model.isSmoker, isTrue);
        expect(model.drinksAlcoholFrequently, isTrue);
        expect(model.allergies, <String>['Penicillin', '7']);
        expect(model.isDarkModeEnabled, isFalse);
        expect(model.languageCode, 'ar');
      },
    );

    test('UT-MOD-PRO-02 uses safe defaults when API data is missing', () {
      final model = ProfileModel.fromApiJson(<String, dynamic>{});

      expect(model.id, isEmpty);
      expect(model.name, isEmpty);
      expect(model.gender, -1);
      expect(model.allergies, isEmpty);
      expect(model.isPregnant, isFalse);
    });

    test(
      'UT-MOD-PRO-03 rejects invalid numbers and unsupported list values',
      () {
        final json = apiProfileJson();
        final data = json['data']! as Map<String, dynamic>;
        final user = data['user']! as Map<String, dynamic>;
        user['gender'] = 'invalid';
        data['allergies'] = 'Penicillin';

        final model = ProfileModel.fromApiJson(json);

        expect(model.gender, -1);
        expect(model.allergies, isEmpty);
      },
    );

    test(
      'UT-MOD-PRO-04 local JSON round-trip preserves every cached field',
      () {
        final original = ProfileModel.fromApiJson(apiProfileJson());
        final restored = ProfileModel.fromJson(original.toJson());

        expect(restored.toJson(), original.toJson());
      },
    );

    test('UT-MOD-PRO-05 converts model into a domain entity', () {
      final entity = ProfileModel.fromApiJson(apiProfileJson()).toEntity();

      expect(entity.id, '12');
      expect(entity.name, 'Ghina');
      expect(entity.isFemale, isTrue);
      expect(entity.isMale, isFalse);
      expect(entity.medications, <String>['Medicine A']);
    });
  });

  test('UT-MOD-PRO-06 update request uses API keys and 1/0 booleans', () {
    const request = UpdateProfileRequestModel(
      name: 'Ghina',
      phone: '0999999999',
      dateOfBirth: '2000-01-02',
      gender: 2,
      address: 'Damascus',
      emergencyContactName: 'Rama',
      emergencyContactRelation: 'Sister',
      emergencyContactPhone: '0988888888',
      isPregnant: false,
      isBreastfeeding: false,
      isSmoker: true,
      drinksAlcoholFrequently: false,
      teethCleaningFrequency: 'twice_daily',
    );

    expect(request.toJson()['date_of_birth'], '2000-01-02');
    expect(request.toJson()['is_pregnant'], 0);
    expect(request.toJson()['is_smoker'], 1);
    expect(request.toJson(), isNot(contains('profile_picture')));
  });
}
