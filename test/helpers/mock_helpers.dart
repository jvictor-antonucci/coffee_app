import 'package:bloc_test/bloc_test.dart';
import 'package:coffe_app/random_image/controller/random_coffee_image_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRandomCoffeeImagesBloc extends MockBloc<RandomCoffeeImageEvent, RandomCoffeeImageState> implements RandomCoffeeImageBloc {}

void registerFallbackValues() {
  registerFallbackValue(RandomCoffeeImageInitial());
  registerFallbackValue(NewRandomCoffeeImage());
}
