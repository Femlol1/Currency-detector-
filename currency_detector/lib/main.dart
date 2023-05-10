import 'package:currency_detector/auth.dart';
import 'package:currency_detector/cd.dart';
import 'package:currency_detector/cdrealtime.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      debugShowCheckedModeBanner: false,
      home: Auth().handleAuthState(),
    );
  }
}

class SwipeNavigation extends StatefulWidget {
  @override
  _SwipeNavigationState createState() => _SwipeNavigationState();
}

class _SwipeNavigationState extends State<SwipeNavigation> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Guru'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              Auth().signOut(); // Call your sign out method here
            },
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          MainPage(),
          CurrencyDetector(),
          CurrencyDetectorrealtime(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(child: Text('Main Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(child: Text('Third Page', style: TextStyle(fontSize: 24))),
    );
  }
}
