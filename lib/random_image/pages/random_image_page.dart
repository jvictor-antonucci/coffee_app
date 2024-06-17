import 'package:coffe_app/random_image/controller/random_coffee_image_bloc.dart';
import 'package:coffe_app/util/debouncer.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class RandomImagePage extends StatefulWidget {
  final RandomCoffeeImageBloc randomCoffeeImageBloc;

  const RandomImagePage({
    super.key,
    required this.randomCoffeeImageBloc,
  });

  @override
  State<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  @override
  void initState() {
    super.initState();
    widget.randomCoffeeImageBloc.add(NewRandomCoffeeImage());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        title: Center(
          child: Text(
            'Random Coffee Image',
            style: TextStyle(color: theme.colorScheme.onSecondary),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BlocBuilder<RandomCoffeeImageBloc, RandomCoffeeImageState>(
            builder: (context, state) {
              switch (state) {
                case RandomCoffeeImageFetch state:
                  return FloatingActionButton(
                    key: const Key('favorite_fab'),
                    onPressed: () {
                      final debouncer = Debouncer();
                      if (state.imagePath != null) {
                        debouncer.run(() {
                          widget.randomCoffeeImageBloc.add(UnFavCoffeeImage(imagePath: state.imagePath!, imageUri: state.imageUri));
                        });
                      } else {
                        debouncer.run(() {
                          widget.randomCoffeeImageBloc.add(FavCoffeeImage(imageUri: state.imageUri));
                        });
                      }
                    },
                    child: _favoriteIcon(state),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            key: const Key('new_image_fab'),
            onPressed: () {
              final debouncer = Debouncer();
              debouncer.run(() {
                widget.randomCoffeeImageBloc.add(NewRandomCoffeeImage());
              });
            },
            label: const Text('new image'),
            icon: const Icon(Icons.coffee_maker_outlined),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width,
            height: 400,
            child: BlocBuilder(
              bloc: widget.randomCoffeeImageBloc,
              builder: (_, state) {
                switch (state) {
                  case RandomCoffeeImageFetch _:
                    return Image.network(
                      (state as dynamic).imageUri,
                      key: const Key('coffee_image_success_widget'),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  case RandomCoffeeImageFailure _:
                    return const Center(
                      key: Key('coffee_image_failure_widget'),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'It was not possible to fetch the image\n Try again requesting another one!',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 18,
                            height: 26 / 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    );
                  case RandomCoffeeImageInitial _:
                  case RandomCoffeeImageLoading _:
                  default:
                    return const Center(
                      key: Key('coffee_image_loader_widget'),
                      child: CircularProgressIndicator(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteIcon(RandomCoffeeImageFetch state) {
    if (state.imagePath != null) {
      if (state is RandomCoffeeImageDownloadInProgress) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Icon(Icons.favorite);
    } else {
      return const Icon(Icons.favorite_border);
    }
  }
}
