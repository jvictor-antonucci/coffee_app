import 'dart:io';

abstract class ICoffeeApi {
  Future<Uri> getCoffeeImage();
  Future<File> downloadCoffeeImage({required Uri imageUri});
  Future<String?> coffeeImageIsFavorite({required String imageName});
  Future<bool> deleteCoffeeImage({required String imagePath});
  Future<List<String>> listAllCoffeeImages();
}
