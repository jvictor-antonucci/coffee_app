import 'dart:io';

import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_api/src/errors/failures.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_storage/image_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  late final Client mockClient;
  late final IImageStorage mockStorage;
  late final CoffeeApiClient apiClient;

  setUpAll(() {
    registerFallbackValues();
    mockClient = ClientMock();
    mockStorage = ImageStorageMock();
    apiClient = CoffeeApiClient(
      httpClient: mockClient,
      storage: mockStorage,
    );
  });

  group('CoffeeApiClient', () {
    group('getCoffeeImage', () {
      test('should return an image uri when http client returns successfully', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => Response('{ "file": "https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg"}', 200),
        );

        final response = await apiClient.getCoffeeImage();

        expect(response, Uri.parse('https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg'));
        verify(() => mockClient.get(Uri.https('coffee.alexflipnote.dev', '/random.json'))).called(1);
      });
      test('should return a failure when http client returns a response with status code 500', () async {
        when(() => mockClient.get(any())).thenAnswer((_) async => Response('{}', 500));

        final call = apiClient.getCoffeeImage();

        expect(call, throwsA(isA<RequestCoffeeImageFailure>()));
        verify(() => mockClient.get(Uri.https('coffee.alexflipnote.dev', '/random.json'))).called(1);
      });
    });
    group('downloadCoffeeImage', () {
      test('should return a File of the image after it is downloaded and stored successfully', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => Response('{ "file": "https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg"}', 200),
        );
        when(() => mockStorage.storeImage(any(), any())).thenAnswer((_) async => 'path/to/image');

        final response = await apiClient.downloadCoffeeImage(imageUri: Uri.parse('https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg'));

        expect(response.path, 'path/to/image');
        verify(() => mockClient.get(Uri.https('coffee.alexflipnote.dev', '/KCKSLeNdPto_coffee.jpg'))).called(1);
        verify(() => mockStorage.storeImage(any(), 'KCKSLeNdPto_coffee.jpg')).called(1);
      });
      test('should return a DownloadCoffeeImageFailure after it failed to download the image', () async {
        when(() => mockClient.get(any())).thenAnswer((_) async => Response('{}', 500));

        final call = apiClient.downloadCoffeeImage(imageUri: Uri.parse('https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg'));

        expect(call, throwsA(isA<DownloadCoffeeImageFailure>()));
        verify(() => mockClient.get(Uri.https('coffee.alexflipnote.dev', '/KCKSLeNdPto_coffee.jpg'))).called(1);
        verifyNever(() => mockStorage.storeImage(any(), 'KCKSLeNdPto_coffee.jpg'));
      });
      test('should return a SaveCoffeeImageFailure after it is failed to save the image', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => Response('{ "file": "https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg"}', 200),
        );
        when(() => mockStorage.storeImage(any(), any())).thenThrow(Exception());

        final call = apiClient.downloadCoffeeImage(imageUri: Uri.parse('https://coffee.alexflipnote.dev/KCKSLeNdPto_coffee.jpg'));

        expect(call, throwsA(isA<SaveCoffeeImageFailure>()));
      });
    });
  });
}
