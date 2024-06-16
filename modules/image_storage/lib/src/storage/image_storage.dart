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
    final directory = Directory(await _localPath);
    if (!(await directory.exists())) return [];

    final imageFiles = directory.listSync(
      recursive: true,
    );

    return List<String>.from(imageFiles.map((e) => e.path));
  }

  @override
  Future<String> getImagePath(String imageName) async {
    return '';
  }

  @override
  Future<String> storeImage(Uint8List image, String imageName) async {
    await Directory(await _localPath).create(recursive: true);
    final File imageFile = File(imageName);
    imageFile.writeAsBytesSync(image);

    return imageFile.path;
  }
}
