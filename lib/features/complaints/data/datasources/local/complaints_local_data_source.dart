import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/cache/cache_keys.dart';
import '../../models/complaint_model.dart';

abstract class ComplaintsLocalDataSource {
  Future<void> cacheComplaints(
      List<ComplaintModel> complaints,
      );

  Future<List<ComplaintModel>> getCachedComplaints();

  Future<void> addComplaintToCache(
      ComplaintModel complaint,
      );
}

class ComplaintsLocalDataSourceImpl
    implements ComplaintsLocalDataSource {
  const ComplaintsLocalDataSourceImpl();

  @override
  Future<void> cacheComplaints(
      List<ComplaintModel> complaints,
      ) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedComplaints = jsonEncode(
      complaints.map((complaint) => complaint.toJson()).toList(),
    );

    await preferences.setString(
      CacheKeys.complaints,
      encodedComplaints,
    );
  }

  @override
  Future<List<ComplaintModel>> getCachedComplaints() async {
    final preferences = await SharedPreferences.getInstance();

    final cachedData = preferences.getString(
      CacheKeys.complaints,
    );

    if (cachedData == null || cachedData.trim().isEmpty) {
      return const [];
    }

    try {
      final decodedData = jsonDecode(cachedData);

      if (decodedData is! List) {
        return const [];
      }

      return decodedData
          .whereType<Map>()
          .map(
            (item) => ComplaintModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } on FormatException {
      return const [];
    } on TypeError {
      return const [];
    }
  }

  @override
  Future<void> addComplaintToCache(
      ComplaintModel complaint,
      ) async {
    final cachedComplaints = await getCachedComplaints();

    final updatedComplaints = cachedComplaints
        .where((item) => item.id != complaint.id)
        .toList();

    updatedComplaints.insert(0, complaint);

    await cacheComplaints(updatedComplaints);
  }
}