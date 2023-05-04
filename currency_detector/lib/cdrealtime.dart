import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class CurrencyDetectorrealtime extends StatefulWidget {
  @override
  _CurrencyDetectorState createState() => _CurrencyDetectorState();
}

class _CurrencyDetectorState extends State<CurrencyDetectorrealtime> {
  File? _image;
  List? _recognitions;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
    _pickImage(); // Automatically open the camera when the page is opened
  }

  Future _loadModel() async {
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

  Future _recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );

    setState(() {
      _recognitions = recognitions;
    });
  }

  Future _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
    });

    _recognizeImage(_image!).then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? Text('No image selected')
                      : Image.file(_image!, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  _recognitions != null
                      ? Text(
                          "Detected: ${_recognitions![0]['label']} (${(_recognitions![0]['confidence'] * 100).toStringAsFixed(0)}%)",
                          style: TextStyle(fontSize: 24),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take a photo'),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
