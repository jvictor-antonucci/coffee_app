import 'package:coffe_app/favorites/controller/favorite_images_bloc.dart';
import 'package:coffe_app/favorites/pages/favorite_images_page.dart';
import 'package:coffe_app/random_image/controller/random_coffee_image_bloc.dart';
import 'package:coffe_app/random_image/pages/random_image_page.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_storage/image_storage.dart';

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IImageStorage>(
      create: (context) => ImageStorage(),
      child: RepositoryProvider<ICoffeeApi>(
        create: (context) => CoffeeApiClient(
          httpClient: Client(),
          storage: RepositoryProvider.of<IImageStorage>(context),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => RandomCoffeeImageBloc(coffeeApi: RepositoryProvider.of<ICoffeeApi>(context)),
            ),
            BlocProvider(
              create: (context) => FavoriteImagesBloc(coffeeApi: RepositoryProvider.of<ICoffeeApi>(context)),
            ),
          ],
          child: MaterialApp(
            title: 'Coffee Image App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown[400] ?? Colors.brown),
              useMaterial3: true,
            ),
            home: const CoffeeAppHomePage(),
          ),
        ),
      ),
    );
  }
}

class CoffeeAppHomePage extends StatefulWidget {
  const CoffeeAppHomePage({super.key});

  @override
  State<CoffeeAppHomePage> createState() => _CoffeeAppHomePageState();
}

class _CoffeeAppHomePageState extends State<CoffeeAppHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int selectedPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      primary: false,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
      ),
      body: SafeArea(
        child: PageView(
          allowImplicitScrolling: false,
          controller: _pageController,
          children: [
            RandomImagePage(randomCoffeeImageBloc: RepositoryProvider.of<RandomCoffeeImageBloc>(context)),
            FavoriteImagesPage(favoriteImagesBloc: RepositoryProvider.of<FavoriteImagesBloc>(context)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Random Image'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My favorites'),
        ],
        onTap: (value) {
          setState(() {
            selectedPageIndex = value;
          });
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: theme.colorScheme.onSecondary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: theme.colorScheme.secondary,
      ),
    );
  }
}
