/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';*/



import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          Text(appState.current.asLowerCase),
        ],
      ),
    );
  }
}

/*void main() {
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
  File? _image; // Makes File type nullable
  String _detectedCurrency = '';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void close() {
    interpreter.dispose();
  }

  Future<void> loadModel() async {
    try {
      await interpreter.loadModel(
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
      detectCurrency(_image!);
    } else {
      print('No image selected.');
    }
  }



Future<void> detectCurrency(File image) async {
  if (image == null) return;

  final interpreter = await Interpreter.fromAsset("assets/model.tflite");

  // Resize the image to the expected input size (e.g., 224x224)
  img.Image originalImage = img.decodeImage(image.readAsBytesSync());
  img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);

  // Convert the image data to a Float32List
  var inputData = imageToFloat32List(resizedImage);

  // Allocate memory for the output tensor
  var outputData = List<List<double>>.filled(1, List<double>.filled(5, 0));


  // Run the interpreter
  await interpreter.runForMultipleInputs([inputData], outputData);

  // Process the output data and update the _detectedCurrency variable
  // ...

  interpreter.dispose();
}

Float32List imageToFloat32List(img.Image image) {
  var convertedBytes = Float32List(1 * 224 * 224 * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (int i = 0; i < 224; i++) {
    for (int j = 0; j < 224; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (img.getRed(pixel)) / 255.0;
      buffer[pixelIndex++] = (img.getGreen(pixel)) / 255.0;
      buffer[pixelIndex++] = (img.getBlue(pixel)) / 255.0;
    }
  }
  return convertedBytes;
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
*/