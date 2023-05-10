import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class CurrencyDetector extends StatefulWidget {
  @override
  _CurrencyDetectorState createState() => _CurrencyDetectorState();
}

class _CurrencyDetectorState extends State<CurrencyDetector> {
  File? _image;
  String _detectedCurrency = '';
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    Tflite.close();
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
      );
      print(res);
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> _getImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      detectCurrency(_image!);
    } else {
      print('No image selected.');
    }
  }

  Future<void> detectCurrency(File image) async {
    if (image == null) return;

    // Load labels
    String labelsData = await rootBundle.loadString('assets/labels.txt');
    List<String> _labels = labelsData.split('\n');

    // Resize the image to the expected input size (e.g., 224x224)
    img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    // Convert the image data to a Float32List
    var inputData = imageToFloat32List(resizedImage as img.Image);

// Allocate memory for the output tensor
    var outputData = List<double>.filled(5, 0);

// Run the interpreter
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

      String detectedLabel = _labels[detectedIndex];
      setState(() {
        _detectedCurrency = detectedLabel;
      });
    });
  }

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

  void _speak(String text) async {
    await flutterTts.setLanguage("en-UK");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Upload or capture an image to detect currency:',
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _getImage(fromCamera: false);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Select from gallery'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    _getImage(fromCamera: true);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Capture with camera'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Detected Currency: $_detectedCurrency',
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                _speak('Detected Currency: $_detectedCurrency');
              },
              icon: Icon(Icons.volume_up),
              label: Text('Speak Result'),
            ),
          ],
        ),
      ),
    );
  }
}
