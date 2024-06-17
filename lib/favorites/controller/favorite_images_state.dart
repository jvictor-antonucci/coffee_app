part of 'favorite_images_bloc.dart';

sealed class FavoriteImagesState {}

final class FavoriteImagesInitial extends FavoriteImagesState {}

final class FavoriteImagesGotSuccessfully extends FavoriteImagesState {
  final List<String> images;

  FavoriteImagesGotSuccessfully({required this.images});
}

final class FavoriteImagesEmptyList extends FavoriteImagesState {}
