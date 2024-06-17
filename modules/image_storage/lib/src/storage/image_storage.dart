import 'dart:io';
import 'dart:typed_data';

import 'package:dependencies/dependencies.dart';
import 'package:image_storage/src/storage/i_image_storage.dart';

class ImageStorage implements IImageStorage {
  Future<String> get _localPath async {
    final documentPath = await getApplicationDocumentsDirectory();
    return '${documentPath.path}/images/';
  }

  @override
  Future<List<String>> get allImages async {
    final localPath = await _localPath;
    final directory = Directory(localPath);
    if (!(await directory.exists())) return [];

    final imageFiles = directory.listSync(
      recursive: true,
    );

    return List<String>.from(imageFiles.map((e) => e.path));
  }

  @override
  Future<String> storeImage(Uint8List image, String imageName) async {
    final localPath = await _localPath;
    await Directory(localPath).create(recursive: true);
    final File imageFile = File('$localPath/${imageName.split('.')[0]}.webp');
    final Uint8List imageCompressedToWebP = await FlutterImageCompress.compressWithList(
      image,
      quality: 96,
      format: CompressFormat.webp,
    );

    imageFile.writeAsBytesSync(imageCompressedToWebP);

    return imageFile.path;
  }

  @override
  Future<String?> imageExists(String imageName) async {
    final localPath = await _localPath;
    final imagePath = '$localPath/$imageName';
    final images = await allImages;

    if (images.contains(imagePath)) return imagePath;
    return null;
  }

  @override
  Future<bool> deleteImage(String imagePath) async {
    try {
      await File(imagePath).delete(recursive: true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
