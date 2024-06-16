import 'dart:io';

import 'package:mocktail/mocktail.dart';

class MockIOOverrides extends Mock implements IOOverrides {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}
