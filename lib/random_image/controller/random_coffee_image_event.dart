part of 'random_coffee_image_bloc.dart';

sealed class RandomCoffeeImageEvent {}

final class NewRandomCoffeeImage extends RandomCoffeeImageEvent {}

final class FavCoffeeImage extends RandomCoffeeImageEvent {
  final String imageUri;

  FavCoffeeImage({required this.imageUri});
}

final class UnFavCoffeeImage extends RandomCoffeeImageEvent {
  final String imagePath;
  final String imageUri;

  UnFavCoffeeImage({
    required this.imagePath,
    required this.imageUri,
  });
}
