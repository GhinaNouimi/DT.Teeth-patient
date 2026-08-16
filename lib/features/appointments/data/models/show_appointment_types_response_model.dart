import '../../domain/entities/appointment_type_entity.dart';

class ShowAppointmentTypesResponseModel {
  final bool success;
  final List<AppointmentTypeModel> appointmentTypes;

  const ShowAppointmentTypesResponseModel({
    required this.success,
    required this.appointmentTypes,
  });

  factory ShowAppointmentTypesResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    if (rawData is! List) {
      throw const FormatException(
        'Invalid appointment types response data.',
      );
    }

    return ShowAppointmentTypesResponseModel(
      success: json['success'] == true,
      appointmentTypes: rawData
          .whereType<Map>()
          .map(
            (item) => AppointmentTypeModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': appointmentTypes
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class AppointmentTypeModel
    extends AppointmentTypeEntity {
  const AppointmentTypeModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.specializations,
  });

  factory AppointmentTypeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawSpecializations =
    json['specializations'];

    final specializations =
    rawSpecializations is List
        ? rawSpecializations
        .whereType<Map>()
        .map(
          (item) =>
          AppointmentTypeSpecializationModel
              .fromJson(
            Map<String, dynamic>.from(item),
          ),
    )
        .toList()
        : <AppointmentTypeSpecializationModel>[];

    return AppointmentTypeModel(
      id: _parseInt(json['id']),
      name:
      json['name']?.toString().trim() ?? '',
      nameEn:
      json['name_en']?.toString().trim() ?? '',
      specializations: specializations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'specializations': specializations
          .map(
            (item) => item
        is AppointmentTypeSpecializationModel
            ? item.toJson()
            : {
          'id': item.id,
          'name': item.name,
        },
      )
          .toList(),
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
}

class AppointmentTypeSpecializationModel
    extends AppointmentTypeSpecializationEntity {
  const AppointmentTypeSpecializationModel({
    required super.id,
    required super.name,
  });

  factory AppointmentTypeSpecializationModel
      .fromJson(
      Map<String, dynamic> json,
      ) {
    return AppointmentTypeSpecializationModel(
      id: AppointmentTypeModel._parseInt(
        json['id'],
      ),
      name:
      json['name']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}