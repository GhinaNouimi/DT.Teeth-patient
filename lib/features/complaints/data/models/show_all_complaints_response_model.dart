import 'complaint_model.dart';

class ShowAllComplaintsResponseModel {
  final bool success;
  final int count;
  final List<ComplaintModel> complaints;

  const ShowAllComplaintsResponseModel({
    required this.success,
    required this.count,
    required this.complaints,
  });

  factory ShowAllComplaintsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawData = json['data'];

    final complaints = rawData is List
        ? rawData
        .whereType<Map>()
        .map(
          (item) => ComplaintModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList()
        : <ComplaintModel>[];

    return ShowAllComplaintsResponseModel(
      success: json['success'] == true,
      count: _parseCount(
        value: json['count'],
        fallback: complaints.length,
      ),
      complaints: complaints,
    );
  }

  static int _parseCount({
    required dynamic value,
    required int fallback,
  }) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}