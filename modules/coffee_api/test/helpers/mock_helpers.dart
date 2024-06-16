import 'dart:typed_data';

import 'package:dependencies/dependencies.dart';
import 'package:image_storage/image_storage.dart';
import 'package:mocktail/mocktail.dart';

class ClientMock extends Mock implements Client {}

class ImageStorageMock extends Mock implements IImageStorage {}

class FakeUri extends Fake implements Uri {}

void registerFallbackValues() {
  registerFallbackValue(FakeUri());
  registerFallbackValue(Uint8List(0));
}
