import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;

  const FullScreenImageViewer({
    super.key,
    this.imageUrl,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: imageFile != null
              ? Image.file(imageFile!)
              : CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}