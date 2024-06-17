import 'dart:convert';
import 'dart:io';

import 'package:coffee_api/src/api/i_coffee_api.dart';
import 'package:coffee_api/src/errors/failures.dart';
import 'package:dependencies/dependencies.dart' as http;
import 'package:image_storage/image_storage.dart';

class CoffeeApiClient implements ICoffeeApi {
  final http.Client _httpClient;
  final IImageStorage _storage;

  static const String _baseUrlCoffee = 'coffee.alexflipnote.dev';

  const CoffeeApiClient({
    required http.Client httpClient,
    required IImageStorage storage,
  })  : _httpClient = httpClient,
        _storage = storage;

  @override
  Future<Uri> getCoffeeImage() async {
    final coffeeRequest = Uri.https(_baseUrlCoffee, '/random.json');

    final coffeeResponse = await _httpClient.get(coffeeRequest);

    if (coffeeResponse.statusCode != 200) {
      throw RequestCoffeeImageFailure();
    }

    final imageUri = Uri.parse(jsonDecode(coffeeResponse.body)['file']);
    return imageUri;
  }

  @override
  Future<File> downloadCoffeeImage({required Uri imageUri}) async {
    final image = await _httpClient.get(imageUri);

    if (image.statusCode != 200) {
      throw DownloadCoffeeImageFailure();
    }

    final imageBytes = image.bodyBytes;

    final imageName = imageUri.toString().split('/').last;

    try {
      final imagePath = await _storage.storeImage(imageBytes, imageName);
      return File(imagePath);
    } catch (e) {
      throw SaveCoffeeImageFailure();
    }
  }

  @override
  Future<String?> coffeeImageIsFavorite({required String imageName}) async {
    return _storage.imageExists(imageName);
  }

  @override
  Future<bool> deleteCoffeeImage({required String imagePath}) {
    return _storage.deleteImage(imagePath);
  }

  @override
  Future<List<String>> listAllCoffeeImages() async {
    return _storage.allImages;
  }
}
