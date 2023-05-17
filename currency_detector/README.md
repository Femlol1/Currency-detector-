# Flutter Currency Detector Application

# currency_guru

This is a Flutter application that uses Machine Learning to detect the type of currency from an image. You can either capture a photo using the device camera or select an image from the gallery, and the app will detect the currency present in the image. The users can also convert currency in the using the application

## Features

1. Currency Detection from image.
2. Options to select image from gallery or capture from camera.
3. Text-to-speech functionality to read out the detected currency.
4. currency convertion of money 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK: To install Flutter, follow the instructions [here](https://flutter.dev/docs/get-started/install)
- Android Studio/VS Code or any other IDE with Flutter plugin installed
- An Android or iOS device or emulator for testing the app

### Installing

1. Clone the repository
   ```
   https://campus.cs.le.ac.uk/gitlab/ug_project/22-23/oo158.git
   ```

2. Move to the project directory
   ```
   cd currency_detector
   ```

3. Get the Flutter packages
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Using the App

1. On launching the app you would need to luch in by clicking the google button or ios button which lets the user log in with thier google or ios account.
2. On launching the app, you'll see a button to capture an image or select an image from the gallery.
3. After selecting an image, the app will process the image and display the detected currency.
4. There's also a button to read out the detected currency using text-to-speech functionality.

## Built With

- [Flutter](https://flutter.dev/) - The UI framework used
- [TFLite Flutter](https://pub.dev/packages/tflite) - Flutter plugin for TensorFlow Lite
- [Image Picker](https://pub.dev/packages/image_picker) - Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera
- [Flutter TTS](https://pub.dev/packages/flutter_tts) - Flutter Text-to-Speech plugin

