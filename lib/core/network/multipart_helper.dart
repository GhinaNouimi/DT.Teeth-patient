import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class MultipartHelper {
  const MultipartHelper._();

  static Future<MultipartFile?> imageFileToMultipart({
    required File? file,
  }) async {
    if (file == null) return null;

    final fileName = path.basename(file.path);

    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
    );
  }
}