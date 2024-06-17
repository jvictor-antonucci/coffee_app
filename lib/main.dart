import 'package:coffe_app/app.dart';
import 'package:coffe_app/coffee_bloc_observer.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const CoffeeBlocObserver();

  runApp(const CoffeeApp());
}
