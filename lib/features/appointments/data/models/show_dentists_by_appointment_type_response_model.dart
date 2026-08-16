import '../../domain/entities/appointment_booking_dentist_entity.dart';

class ShowDentistsByAppointmentTypeResponseModel {
  final bool success;
  final List<AppointmentBookingDentistModel> dentists;

  const ShowDentistsByAppointmentTypeResponseModel({
    required this.success,
    required this.dentists,
  });

  factory ShowDentistsByAppointmentTypeResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! List) {
      throw const FormatException(
        'Invalid dentists by appointment type response data.',
      );
    }

    return ShowDentistsByAppointmentTypeResponseModel(
      success: json['success'] == true,
      dentists: rawData
          .whereType<Map>()
          .map(
            (item) =>
            AppointmentBookingDentistModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': dentists
          .map(
            (dentist) => dentist.toJson(),
      )
          .toList(),
    };
  }
}

class AppointmentBookingDentistModel
    extends AppointmentBookingDentistEntity {
  const AppointmentBookingDentistModel({
    required super.id,
    required super.name,
    super.profilePicture,
    required super.specializationName,
    required super.specializationNameEn,
    required super.yearsOfExperience,
    required super.averageRating,
    super.bio,
  });

  factory AppointmentBookingDentistModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final specialization =
    _parseMap(json['specialization']);

    return AppointmentBookingDentistModel(
      id: _parseInt(json['id']),
      name:
      json['name']?.toString().trim() ?? '',
      profilePicture: _parseNullableString(
        json['profile_picture'],
      ),
      specializationName:
      specialization['ar']
          ?.toString()
          .trim() ??
          '',
      specializationNameEn:
      specialization['en']
          ?.toString()
          .trim() ??
          '',
      yearsOfExperience: _parseInt(
        json['years_of_experience'],
      ),
      averageRating: _parseDouble(
        json['average_rating'],
      ),
      bio: _parseNullableString(
        json['bio'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_picture': profilePicture,
      'specialization': {
        'ar': specializationName,
        'en': specializationNameEn,
      },
      'years_of_experience': yearsOfExperience,
      'average_rating':
      averageRating.toStringAsFixed(2),
      'bio': bio,
    };
  }

  static int _parseInt(
      dynamic value,
      ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _parseDouble(
      dynamic value,
      ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  static Map<String, dynamic> _parseMap(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return const {};
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final normalized =
    value.toString().trim();

    if (normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return null;
    }

    return normalized;
  }
}