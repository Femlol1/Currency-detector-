import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:async';

class CurrencyDetectorHomePage extends StatefulWidget {
  @override
  _CurrencyDetectorHomePageState createState() =>
      _CurrencyDetectorHomePageState();
}

class _CurrencyDetectorHomePageState extends State<CurrencyDetectorHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // Makes File type nullable
  String _detectedCurrency = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.pickImage(
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

    final interpreter = await Interpreter.fromAsset("assets/model.tflite");

    // Load labels
    String labelsData = await rootBundle.loadString('assets/labels.txt');
    List<String> _labels = labelsData.split('\n');

    // Resize the image to the expected input size (e.g., 224x224)
    print("Picked image: $_image");
    img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
    print("Decoded image: $originalImage");
    img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    // Convert the image data to a Float32List
    var inputData = imageToFloat32List(resizedImage);
    print("Input data: $inputData");

    // Allocate memory for the output tensor
    var outputData = List<List<double>>.filled(1, List<double>.filled(5, 0));

    // Run the interpreter
    interpreter
        .runForMultipleInputs([inputData], outputData as Map<int, Object>);

    // Process the output data and update the _detectedCurrency variable
    int detectedIndex = outputData[0].indexOf(outputData[0].reduce(max));
    String detectedLabel = _labels[detectedIndex];
    setState(() {
      _detectedCurrency = detectedLabel;
    });

    interpreter.close();
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
          ],
        ),
      ),
    );
  }
}
