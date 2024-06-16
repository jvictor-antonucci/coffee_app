import 'dart:typed_data';

abstract class IImageStorage {
  Future<List<String>> get allImages;
  Future<String> getImagePath(String imageName);
  Future<String> storeImage(Uint8List image, String imageName);
}
