# coffe_app

Flutter app that request random coffee images from the coffee.alexflipnote.dev api and allows user to favorite them and store it locally on their mobile device.

## External Packages

- BLoC and Flutter_BLoC packages for the view controllers
- Http for the http client
- Path_Provider to help getting the local path to store the images
- Flutter_Image_Compress to compress the images to WebP for a better manage of memory

## Instructions

**First Step:** open the terminal and run `make get-packages` or run `dart run scripts/get_packages.dart` from the root of the project to install all the packages via flutter pub get.

**Second Step:** run the project with `flutter run` or with your IDE's visual interface. 