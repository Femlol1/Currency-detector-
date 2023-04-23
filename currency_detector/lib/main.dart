import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(CurrencyDetectorApp());
}

class CurrencyDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyDetectorHomePage(),
    );
  }
}

class CurrencyDetectorHomePage extends StatefulWidget {
  @override
  _CurrencyDetectorHomePageState createState() => _CurrencyDetectorHomePageState();
}

class _CurrencyDetectorHomePageState extends State<CurrencyDetectorHomePage> {
  final ImagePicker _picker = ImagePicker();
  File _image;
  String _detectedCurrency = '';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _getImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.getImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      detectCurrency(_image);
    } else {
      print('No image selected.');
    }
  }

  Future<void> detectCurrency(File image) async {
    if (image == null) return;

    final result = await Tflite.runModelOnImage(
      path: image.path,
      // Set the appropriate parameters based on your model
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _detectedCurrency = result[0]['label'];
      });
    } else {
      print('No currency detected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Detector'),
      ),
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
