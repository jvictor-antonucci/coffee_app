import 'dart:io';

import 'package:coffee_api/coffee_api.dart';
import 'package:dependencies/dependencies.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        coffeeApi: CoffeeApiClient(httpClient: http.Client()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ICoffeeApi _coffeeApi;
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
    required ICoffeeApi coffeeApi,
  }) : _coffeeApi = coffeeApi;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uri? imageUri;

  void getImage() async {
    final uri = await widget._coffeeApi.getCoffeeImage();
    setState(() {
      imageUri = uri;
    });
  }

  void favoriteImage() async {
    if (imageUri == null) return;
    final File imageFile = await widget._coffeeApi.downloadCoffeeImage(imageUri: imageUri!);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Random Coffee Image:',
            ),
            SizedBox(
              width: size.width * .8,
              height: size.height * .4,
              child: imageUri != null
                  ? Image.network(
                      imageUri.toString(),
                      fit: BoxFit.contain,
                    )
                  : const Icon(Icons.no_cell_rounded),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: favoriteImage,
              label: const Row(
                children: [
                  Text('favorite'),
                  Icon(Icons.favorite),
                ],
              ),
            ),
            const Spacer(),
            FloatingActionButton.extended(
              label: const Row(
                children: [
                  Text('get random'),
                  Icon(Icons.refresh),
                ],
              ),
              onPressed: getImage,
              tooltip: 'Increment',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
