import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtil {
  static Future<Uint8List> compressImageMobile(XFile file) async {
    final originalBytes = await file.readAsBytes();
    if (originalBytes.lengthInBytes <= 4 * 1024 * 1024) {
      return originalBytes;
    }

    final targetPath = path.join(
      (await getTemporaryDirectory()).path,
      "compressed_${path.basename(file.path)}",
    );

    int quality = 90;
    XFile? compressedFile;

    while (quality >= 10) {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
      );

      if (result != null && await result.length() <= 4 * 1024 * 1024) {
        compressedFile = result;
        break;
      }
      quality -= 10;
    }

    if (compressedFile == null) {
      throw Exception("Couldn't compress image under 4MB");
    }

    return await compressedFile.readAsBytes();
  }

  static Future<Uint8List> compressImageWeb(XFile file, {int maxSizeMB = 4}) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Could not decode image.");
    }

    int quality = 90;
    Uint8List? compressed;

    while (quality >= 10) {
      final jpeg = img.encodeJpg(image, quality: quality);
      if (jpeg.length <= maxSizeMB * 1024 * 1024) {
        compressed = Uint8List.fromList(jpeg);
        break;
      }
      quality -= 10;
    }

    if (compressed == null) {
      throw Exception("Unable to compress image below ${maxSizeMB}MB");
    }

    return compressed;
  }
}
