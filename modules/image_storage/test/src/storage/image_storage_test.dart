import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_storage/image_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  final IImageStorage imageStorage = ImageStorage();
  final IOOverrides mockIOOverrides = MockIOOverrides();
  final Directory mockDirectory = MockDirectory();
  final List<FileSystemEntity> fakeDirectory = [];

  setUpAll(() {
    IOOverrides.global = mockIOOverrides;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );

    when(() => mockIOOverrides.createDirectory(any())).thenReturn(mockDirectory);
    when(() => mockDirectory.listSync(recursive: any(named: 'recursive'))).thenReturn(fakeDirectory);
  });

  group('ImageStorage', () {
    group('allImages', () {
      test('should return an empty list when there is no image in the directory', () async {
        when(() => mockDirectory.exists()).thenAnswer((_) async => false);

        final response = await imageStorage.allImages;

        expect(response, []);
      });
    });
  });
}
