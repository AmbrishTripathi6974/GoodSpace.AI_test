import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressor {
  static Future<File?> compressImage(File file, {int quality = 70}) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.absolute.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality, // lower means more compression
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print("Error compressing image: $e");
      return null;
    }
  }
}
