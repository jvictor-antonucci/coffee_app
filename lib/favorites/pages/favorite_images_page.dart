import 'package:coffe_app/favorites/controller/favorite_images_bloc.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class FavoriteImagesPage extends StatefulWidget {
  final FavoriteImagesBloc favoriteImagesBloc;

  const FavoriteImagesPage({super.key, required this.favoriteImagesBloc});

  @override
  State<FavoriteImagesPage> createState() => _FavoriteImagesPageState();
}

class _FavoriteImagesPageState extends State<FavoriteImagesPage> {
  @override
  void initState() {
    super.initState();
    widget.favoriteImagesBloc.add(ListAllImagesEvent());
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
            'My Favorites',
            style: TextStyle(color: theme.colorScheme.onSecondary),
          ),
        ),
      ),
      body: BlocBuilder<FavoriteImagesBloc, FavoriteImagesState>(
        builder: (context, state) {
          switch (state) {
            case FavoriteImagesGotSuccessfully state:
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: size.width * .5),
                itemCount: state.images.length,
                itemBuilder: (context, index) => SizedBox(
                  width: size.width * .25,
                  height: 80,
                  child: Image.asset(state.images[index]),
                ),
              );
            case FavoriteImagesEmptyList _:
            default:
              return const Center(
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
          }
        },
      ),
    );
  }
}
