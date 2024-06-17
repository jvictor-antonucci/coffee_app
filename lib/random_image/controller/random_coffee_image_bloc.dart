import 'package:coffee_api/coffee_api.dart';
import 'package:dependencies/dependencies.dart';

part 'random_coffee_image_event.dart';
part 'random_coffee_image_state.dart';

class RandomCoffeeImageBloc extends Bloc<RandomCoffeeImageEvent, RandomCoffeeImageState> {
  final ICoffeeApi _coffeeApi;

  RandomCoffeeImageBloc({required ICoffeeApi coffeeApi})
      : _coffeeApi = coffeeApi,
        super(RandomCoffeeImageInitial()) {
    on<NewRandomCoffeeImage>(_handleNewRandomCoffeeImage);
    on<FavCoffeeImage>(_handleFavCoffeeImage);
    on<UnFavCoffeeImage>(_handleUnFavCoffeeImage);
  }

  Future<void> _handleNewRandomCoffeeImage(
    NewRandomCoffeeImage event,
    Emitter<RandomCoffeeImageState> emit,
  ) async {
    try {
      emit(RandomCoffeeImageLoading());
      final image = await _coffeeApi.getCoffeeImage();
      final imagePath = await _coffeeApi.coffeeImageIsFavorite(imageName: image.path);
      emit(RandomCoffeeImageFetch(
        imageUri: image.toString(),
        imagePath: imagePath,
      ));
    } catch (e) {
      emit(RandomCoffeeImageFailure());
    }
  }

  Future<void> _handleFavCoffeeImage(
    FavCoffeeImage event,
    Emitter<RandomCoffeeImageState> emit,
  ) async {
    final imageUri = event.imageUri;
    try {
      emit(RandomCoffeeImageDownloadInProgress(imageUri: imageUri));
      final response = await _coffeeApi.downloadCoffeeImage(imageUri: Uri.parse(imageUri));
      if (response.existsSync()) {
        emit(RandomCoffeeImageDownloadSuccessfully(imageUri: imageUri, imagePath: response.path));
        return;
      }
      emit(RandomCoffeeImageDownloadFailure(imageUri: imageUri));
    } catch (e) {
      emit(RandomCoffeeImageDownloadFailure(imageUri: imageUri));
    }
  }

  Future<void> _handleUnFavCoffeeImage(
    UnFavCoffeeImage event,
    Emitter<RandomCoffeeImageState> emit,
  ) async {
    final imagePath = event.imagePath;
    final imageUri = event.imageUri;
    try {
      final isDeleted = await _coffeeApi.deleteCoffeeImage(imagePath: imagePath);
      if (isDeleted) {
        emit(RandomCoffeeImageFetch(
          imagePath: null,
          imageUri: imageUri,
        ));
        return;
      }
      emit(RandomCoffeeImageFetch(
        imagePath: imagePath,
        imageUri: imageUri,
      ));
    } catch (e) {
      emit(RandomCoffeeImageFetch(
        imagePath: imagePath,
        imageUri: imageUri,
      ));
    }
  }
}
