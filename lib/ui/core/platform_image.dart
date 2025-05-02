import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

class PlatformImage extends StatelessWidget {
  final XFile xFile;
  final BoxFit fit;
  final double? width;
  final double? height;

  const PlatformImage({
    super.key,
    required this.xFile,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: xFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Error loading image");
          } else if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: fit,
              width: width,
              height: height,
            );
          } else {
            return const Text("No image data");
          }
        },
      );
    } else {
      return Image.file(
        File(xFile.path),
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}
