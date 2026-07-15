import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../../models/add_complaint_request_model.dart';
import '../../models/add_complaint_response_model.dart';
import '../../models/complaint_model.dart';
import '../../models/show_all_complaints_response_model.dart';

abstract class ComplaintsRemoteDataSource {
  Future<List<ComplaintModel>> showAllComplaints();

  Future<ComplaintModel> addComplaint(
      AddComplaintRequestModel request,
      );
}

class ComplaintsRemoteDataSourceImpl
    implements ComplaintsRemoteDataSource {
  final Dio dio;

  const ComplaintsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<ComplaintModel>> showAllComplaints() async {
    final response = await dio.get(
      ApiConstants.patientShowAllComplaints,
    );

    final responseData = _parseResponseData(response.data);

    final responseModel =
    ShowAllComplaintsResponseModel.fromJson(responseData);

    return responseModel.complaints;
  }

  @override
  Future<ComplaintModel> addComplaint(
      AddComplaintRequestModel request,
      ) async {
    final response = await dio.post(
      ApiConstants.patientAddComplaint,
      data: request.toJson(),
    );

    final responseData = _parseResponseData(response.data);

    final responseModel =
    AddComplaintResponseModel.fromJson(responseData);

    return responseModel.complaint;
  }

  Map<String, dynamic> _parseResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException(
      'Invalid complaints response format.',
    );
  }
}