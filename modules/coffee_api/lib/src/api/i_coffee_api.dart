import 'dart:io';

abstract class ICoffeeApi {
  Future<Uri> getCoffeeImage();
  Future<File> downloadCoffeeImage({required Uri imageUri});
}
