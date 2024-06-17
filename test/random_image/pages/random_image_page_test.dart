import 'dart:io';

import 'package:coffe_app/favorites/controller/favorite_images_bloc.dart';
import 'package:coffe_app/random_image/controller/random_coffee_image_bloc.dart';
import 'package:coffe_app/random_image/pages/random_image_page.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_storage/image_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  late RandomCoffeeImageBloc mockBloc;

  setUp(() {
    registerFallbackValues();
    mockBloc = MockRandomCoffeeImagesBloc();
  });

  Widget setUpWidget(Widget widgetToTest) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: mockBloc),
      ],
      child: MaterialApp(
        title: 'Coffee Image App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown[400] ?? Colors.brown),
          useMaterial3: true,
        ),
        home: widgetToTest,
      ),
    );
  }

  group('randomImagePage', () {
    testWidgets('renders loader and FAB for initial state', (tester) async {
      when(() => mockBloc.state).thenReturn(RandomCoffeeImageInitial());
      await tester.pumpWidget(setUpWidget(RandomImagePage(randomCoffeeImageBloc: mockBloc)));

      const newImageFabKey = Key('new_image_fab');
      const loaderKey = Key('coffee_image_loader_widget');

      expect(find.byKey(newImageFabKey), findsOne);
      expect(find.byKey(loaderKey), findsOne);
    });
    testWidgets('renders text and fab for failure state', (tester) async {
      when(() => mockBloc.state).thenReturn(RandomCoffeeImageFailure());
      await tester.pumpWidget(setUpWidget(RandomImagePage(randomCoffeeImageBloc: mockBloc)));

      const newImageFabKey = Key('new_image_fab');
      const failureTextKey = Key('coffee_image_failure_widget');

      expect(find.byKey(newImageFabKey), findsOne);
      expect(find.byKey(failureTextKey), findsOne);
    });
  });
}
