part of 'random_coffee_image_bloc.dart';

sealed class RandomCoffeeImageState {}

final class RandomCoffeeImageInitial extends RandomCoffeeImageState {}

final class RandomCoffeeImageLoading extends RandomCoffeeImageState {}

final class RandomCoffeeImageFetch extends RandomCoffeeImageState {
  final String imageUri;
  final String? imagePath;

  RandomCoffeeImageFetch({
    required this.imageUri,
    this.imagePath,
  });
}

final class RandomCoffeeImageFailure extends RandomCoffeeImageState {}

final class RandomCoffeeImageDownloadInProgress extends RandomCoffeeImageFetch {
  RandomCoffeeImageDownloadInProgress({required super.imageUri});
}

final class RandomCoffeeImageDownloadSuccessfully extends RandomCoffeeImageFetch {
  RandomCoffeeImageDownloadSuccessfully({
    required super.imageUri,
    super.imagePath,
  });
}

final class RandomCoffeeImageDownloadFailure extends RandomCoffeeImageFetch {
  RandomCoffeeImageDownloadFailure({required super.imageUri});
}
