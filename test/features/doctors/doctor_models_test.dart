import 'package:dt_teeth/features/doctors/data/models/add_dentist_rate_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/dentist_details_model.dart';
import 'package:dt_teeth/features/doctors/data/models/dentist_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_all_dentists_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentist_details_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentist_rate_response_model.dart';
import 'package:dt_teeth/features/doctors/data/models/show_dentists_by_specialization_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> dentistJson() => <String, dynamic>{
  'id': 4,
  'user_id': 10,
  'name': 'Dr. Lina',
  'email': 'lina@test.com',
  'phone': '0999',
  'role': 2,
  'specialization_name': 'طب أطفال',
  'specialization_name_en': 'Pediatric Dentistry',
  'profile_picture': 'lina.jpg',
};

Map<String, dynamic> detailsJson() => <String, dynamic>{
  'id': 4,
  'name': 'Dr. Lina',
  'profile_picture': null,
  'specialization': <String, dynamic>{'ar': 'طب أطفال', 'en': 'Pediatric'},
  'years_of_experience': 7,
  'average_rating': 3.8,
  'bio': 'Bio',
};

void main() {
  test('UT-MOD-DOC-01 parses and serializes dentist list item', () {
    final model = DentistModel.fromJson(dentistJson());
    expect(model.id, 4);
    expect(model.specializationNameEn, 'Pediatric Dentistry');
    expect(model.toJson(), dentistJson());
  });

  test('UT-MOD-DOC-02 dentist model safely defaults missing fields', () {
    final model = DentistModel.fromJson(<String, dynamic>{});
    expect(model.id, 0);
    expect(model.name, isEmpty);
    expect(model.profilePicture, isNull);
  });

  test(
    'UT-MOD-DOC-03 parses details and normalizes numeric rating to String',
    () {
      final model = DentistDetailsModel.fromJson(detailsJson());
      expect(model.yearsOfExperience, 7);
      expect(model.averageRating, '3.8');
      expect(model.specializationAr, 'طب أطفال');
    },
  );

  test('UT-MOD-DOC-04 details round-trip preserves nested specialization', () {
    final model = DentistDetailsModel.fromJson(detailsJson());
    final restored = DentistDetailsModel.fromJson(model.toJson());
    expect(restored.toJson(), model.toJson());
  });

  test('UT-MOD-DOC-05 list response filters malformed list elements', () {
    final response = ShowAllDentistsResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'data': <dynamic>[dentistJson(), 'invalid', 5],
    });
    expect(response.success, isTrue);
    expect(response.data, hasLength(1));
    expect(response.data.single.name, 'Dr. Lina');
  });

  test('UT-MOD-DOC-06 details response returns null for malformed data', () {
    final response = ShowDentistDetailsResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'data': <String>[],
    });
    expect(response.data, isNull);
  });

  test('UT-MOD-DOC-07 specialization response parses count and list', () {
    final response = ShowDentistsBySpecializationResponseModel.fromJson(
      <String, dynamic>{
        'success': true,
        'count': 1,
        'data': <dynamic>[detailsJson()],
      },
    );
    expect(response.count, 1);
    expect(response.data.single.id, 4);
    expect(response.toJson()['data'], isA<List<dynamic>>());
  });

  test('UT-MOD-DOC-08 rating responses parse values and safe defaults', () {
    final shown = ShowDentistRateResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'data': <String, dynamic>{'rating': 4},
    });
    final added = AddDentistRateResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'message': 'ok',
      'data': <String, dynamic>{'average_rating': 5},
    });
    final malformed = ShowDentistRateResponseModel.fromJson(
      <String, dynamic>{},
    );
    expect(shown.rating, 4);
    expect(added.averageRating, 5);
    expect(malformed.rating, 0);
  });
}
