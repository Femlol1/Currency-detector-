import 'dart:io';
import 'dart:typed_data';
import 'package:currency_detector/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class CurrencyDetector extends StatefulWidget {
  @override
  CurrencyDetectorState createState() => CurrencyDetectorState();
}

class CurrencyDetectorState extends State<CurrencyDetector> {
  // It has three instance variables:
  // _image holds the selected image file.
  File? _image;
  // _detectedCurrency holds the result of the currency detection.
  String _detectedCurrency = '';
  // flutterTts is an instance of FlutterTts for text-to-speech functionality.
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadModel(); // It loads the machine learning model.
  }

  // _loadModel method loads the machine learning model from assets.
  Future<void> _loadModel() async {
    Tflite.close(); // It ensures that any previous model is closed.
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
      );
      print(res); // It prints the result of loading the model.
    } catch (e) {
      print(
          'Failed to load model: $e'); // If loading fails, it prints an error message.
    }
  }

  // _getImage method picks an image either from the camera or the gallery,
  Future<void> _getImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // It sets the selected image file.
      });
      detectCurrency(
          _image!); // It then calls detectCurrency method to detect the currency in the image.
    } else {
      print(
          'No image selected.'); // If no image is selected, it prints the message.
    }
  }

  // detectCurrency method detects the currency in the given image file.
  Future<void> detectCurrency(File image) async {
    // Load labels
    String labelsData = await rootBundle.loadString('assets/labels.txt');
    List<String> labels = labelsData.split('\n');

    // Resize the image to the expected input size (e.g., 224x224)
    img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    // Convert the image data to a Float32List
    var inputData = imageToFloat32List(resizedImage);

// Allocate memory for the output tensor

// It runs the model on the image data and sets the detected currency.
    Tflite.runModelOnBinary(
      binary: inputData.buffer.asUint8List(),
      numResults: 5,
      threshold: 0.1,
    ).then((recognitions) {
      int detectedIndex = -1;
      double maxConfidence = -1.0;

      for (final recognition in recognitions!) {
        if (recognition['confidence'] as double > maxConfidence) {
          maxConfidence = recognition['confidence'];
          detectedIndex = recognition['index'];
        }
      }

      String detectedLabel = labels[detectedIndex];
      List<String> splitLabel = detectedLabel.split(" ");

      if (splitLabel.length > 1) {
        setState(() {
          _detectedCurrency = splitLabel[1]; // It sets the detected currency.
        });
      }
    });
  }

  // imageToFloat32List method converts an image to a Float32List, which is the format required for running the model.
  Float32List imageToFloat32List(img.Image image) {
    var convertedBytes = Float32List(1 * 224 * 224 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int i = 0; i < 224; i++) {
      for (int j = 0; j < 224; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = pixel.r / 255.0; // Red channel
        buffer[pixelIndex++] = pixel.g / 255.0; // Green channel
        buffer[pixelIndex++] = pixel.b / 255.0; // Blue channel
      }
    }
    return convertedBytes;
  }

  // _speak method uses the FlutterTts instance to speak the given text.
  void _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeModel>(context).textSize;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Upload or capture an image to detect currency:',
              style: TextStyle(fontSize: textSize),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _getImage(fromCamera: false);
                      },
                      icon: Icon(Icons.image),
                      label: Text('Select from gallery',
                          style: TextStyle(fontSize: textSize)),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _getImage(fromCamera: true);
                      },
                      icon: Icon(Icons.camera),
                      label: Text('Capture with camera',
                          style: TextStyle(fontSize: textSize)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Detected Currency: $_detectedCurrency',
              style: TextStyle(fontSize: textSize),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                _speak('Detected Currency: $_detectedCurrency');
              },
              icon: Icon(Icons.volume_up),
              label: Text('Speak Result', style: TextStyle(fontSize: textSize)),
            ),
          ],
        ),
      ),
    );
  }
}
