import 'package:currency_detector/cd.dart';
import 'package:currency_detector/cdrealtime.dart';
import 'package:flutter/material.dart';

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
      home: SwipeNavigation(),
      //home: CurrencyDetectorHomePage(),
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
      ),
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          MainPage(),
          CurrencyDetectorHomePage(),
          CurrencyDetector(),
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
