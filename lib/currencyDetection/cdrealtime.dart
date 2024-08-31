import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

class CurrencyDetectorrealtime extends StatefulWidget {
  @override
  CurrencyDetectorState createState() => CurrencyDetectorState();
}

class CurrencyDetectorState extends State<CurrencyDetectorrealtime>
    with AutomaticKeepAliveClientMixin {
  bool isModelRunning = false; // add this flag
  List<CameraDescription>? cameras;
  CameraController? controller;
  List? _recognitions;

  bool _loading = true;
  final FlutterTts flutterTts = FlutterTts();

  @override
  bool get wantKeepAlive =>
      true; // This will preserve the State between tab changes.

  @override
  void deactivate() {
    // This is called when the State is removed from the tree.
    if (controller != null && controller!.value.isInitialized) {
      controller!.stopImageStream();
      controller!.dispose();
    }
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();

    _loadModel().then((value) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });

    _initCamera();
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

  void _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.medium);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      controller!.startImageStream((CameraImage img) {
        if (!controller!.value.isStreamingImages || isModelRunning) return;

        isModelRunning = true; // Set the flag to true before running the model

        try {
          Tflite.runModelOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 0.0,
            imageStd: 255.0,
            rotation: 90,
            numResults: 2,
            threshold: 0.1,
            asynch: true,
          ).then((recognitions) {
            setState(() {
              _recognitions = recognitions;
            });
            isModelRunning =
                false; // Reset the flag after the model has finished running
          }).catchError((error) {
            print('Error running model: $error');
            isModelRunning = false; // Reset the flag even if an error occurred
          });
        } catch (e) {
          print('Error running model: $e');
          isModelRunning = false; // Reset the flag even if an error occurred
        }
      });
    });
  }

  void _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                CameraPreview(controller!),
                Positioned(
                  bottom: 50, // Adjust this value as per your requirement.
                  left: 20,
                  right: 20,
                  child: _recognitions != null
                      ? Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.black54,
                          child: Text(
                            "Detected: ${_recognitions![0]['label'].split(" ")[1]} (${(_recognitions![0]['confidence'] * 100).toStringAsFixed(0)}%)",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_recognitions != null) {
            _speak(
                "Detected: ${_recognitions![0]['label'].split(" ")[1]} (${(_recognitions![0]['confidence'] * 100).toStringAsFixed(0)}%)");
          }
        },
        tooltip: 'Speak Result',
        child: Icon(Icons.volume_up),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    Tflite.close();
    super.dispose();
  }
}
 





// class CurrencyDetectorState extends State<CurrencyDetectorrealtime> {
//   File? _image; // _image holds the selected image file.
//   List?
//       _recognitions; // _recognitions holds the result of the currency detection.

//   bool _loading = false; // _loading is a boolean to manage the loading state.
//   // flutterTts is an instance of FlutterTts for text-to-speech functionality.
//   final FlutterTts flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();
//     _loading = true;
//     _loadModel().then((value) {
//       // It loads the machine learning model.
//       setState(() {
//         _loading = false; // After loading the model, it sets _loading to false.
//       });
//     });
//     _pickImage(); // Automatically open the camera when the page is opened
//   }

//   Future _loadModel() async {
//     Tflite.close();
//     try {
//       String? res = await Tflite.loadModel(
//         // It ensures that any previous model is closed.
//         model: "assets/model.tflite",
//         labels: "assets/labels.txt",
//         numThreads: 1,
//       );
//       print(res); // It prints the result of loading the model.
//     } catch (e) {
//       print(
//           'Failed to load model: $e'); // If loading fails, it prints an error message.
//     }
//   }

//   // _recognizeImage method recognizes the currency in the given image file.
//   Future _recognizeImage(File image) async {
//     var recognitions = await Tflite.runModelOnImage(
//       path: image.path,
//       imageMean: 0.0,
//       imageStd: 255.0,
//       numResults: 2,
//       threshold: 0.1,
//       asynch: true,
//     );

//     for (var recognition in recognitions!) {
//       List<String> splitLabel = recognition['label'].split(" ");
//       if (splitLabel.length > 1) {
//         recognition['label'] = splitLabel[1];
//       }
//     }

//     setState(() {
//       _recognitions = recognitions; // It sets the recognized currencies.
//     });
//   }

//   // _pickImage method picks an image from the camera.
//   Future _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile == null) return;

//     setState(() {
//       _loading = true; // It sets _loading to true when an image is picked.
//       _image = File(pickedFile.path); // It sets the picked image.
//     });

//     _recognizeImage(_image!).then((_) {
//       setState(() {
//         _loading =
//             false; // It sets _loading to false after recognizing the image.
//       });
//     });
//   }

// // _speak method uses the FlutterTts instance to speak the given text.
//   void _speak(String text) async {
//     await flutterTts.setLanguage("en-UK");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double textSize = Provider.of<TextSizeModel>(context).textSize;

//     return Scaffold(
//       body: _loading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _image == null
//                       ? Text('No image selected',
//                           style: TextStyle(fontSize: textSize))
//                       : Image.file(_image!, fit: BoxFit.cover),
//                   SizedBox(height: 20),
//                   _recognitions != null
//                       ? Text(
//                           "Detected: ${_recognitions![0]['label']} (${(_recognitions![0]['confidence'] * 100).toStringAsFixed(0)}%)",
//                           style: TextStyle(fontSize: textSize),
//                         )
//                       : Container(),
//                   SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: Icon(Icons.camera_alt),
//                     label: Text('Take a photo',
//                         style: TextStyle(fontSize: textSize)),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (_recognitions != null) {
//                         _speak(
//                             "Detected: ${_recognitions![0]['label']} (${(_recognitions![0]['confidence'] * 100).toStringAsFixed(0)}%)");
//                       }
//                     },
//                     icon: Icon(Icons.volume_up),
//                     label: Text('Speak Result',
//                         style: TextStyle(fontSize: textSize)),
//                   ),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImage,
//         tooltip: 'Pick Image',
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }
// }
