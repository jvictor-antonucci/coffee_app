import 'package:coffee_api/coffee_api.dart';
import 'package:dependencies/dependencies.dart';

part 'favorite_images_event.dart';
part 'favorite_images_state.dart';

class FavoriteImagesBloc extends Bloc<FavoriteImagesEvent, FavoriteImagesState> {
  final ICoffeeApi _coffeeApi;

  FavoriteImagesBloc({required ICoffeeApi coffeeApi})
      : _coffeeApi = coffeeApi,
        super(FavoriteImagesInitial()) {
    on<ListAllImagesEvent>(_handleListAllImages);
  }

  Future<void> _handleListAllImages(ListAllImagesEvent event, Emitter<FavoriteImagesState> emit) async {
    final images = await _coffeeApi.listAllCoffeeImages();
    if (images.isNotEmpty) {
      emit(FavoriteImagesGotSuccessfully(images: images));
      return;
    }

    emit(FavoriteImagesEmptyList());
  }
}
