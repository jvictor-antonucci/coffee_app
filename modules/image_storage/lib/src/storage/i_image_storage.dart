import 'dart:typed_data';

abstract class IImageStorage {
  Future<List<String>> get allImages;
  Future<String?> imageExists(String imageName);
  Future<String> storeImage(Uint8List image, String imageName);
  Future<bool> deleteImage(String imagePath);
}
