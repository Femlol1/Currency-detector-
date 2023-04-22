import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(CurrencyGuruApp());
}

class CurrencyGuruApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyGuruHomePage(),
    );
  }
}

class CurrencyGuruHomePage extends StatefulWidget {
  @override
  _CurrencyGuruHomePageState createState() => _CurrencyGuruHomePageState();
}

class _CurrencyGuruHomePageState extends State<CurrencyGuruHomePage> {
  final ImagePicker _picker = ImagePicker();
  File _image;

   Future<void> _getImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.getImage(
      source: fromCamera ? Image
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Process the image and detect currency
       detectCurrency(_image);
    } else {
      print('No image selected.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Guru'),
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
                    // Handle image selection from gallery
                    _getImage(fromCamera: false);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Select from gallery'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle image capture from camera
                    _getImage(fromCamera: true);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Capture with camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
        model: "assets/your_model.tflite",
        labels: "assets/your_labels.txt", // Add your labels file if needed
      );
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> detectCurrency(File image) async {
    if (image == null) return;

    final result = await Tflite.runModelOnImage(
      path: image.path,
      // Set the appropriate parameters based on your model
    );

    if (result != null && result.isNotEmpty) {
      // Display detected currency and converted values
      print(result);
    } else {
      print('No currency detected.');
    }
  }
}

