import 'package:currency_detector/auth.dart';
import 'package:currency_detector/cd.dart';
import 'package:currency_detector/cdrealtime.dart';
import 'package:currency_detector/settings.dart';
import 'package:currency_detector/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: CurrencyDetectorApp(),
    ),
  );
}

class CurrencyDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, child) => MaterialApp(
        title: 'Currency Detector',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        home: Auth().handleAuthState(),
      ),
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
          TextButton.icon(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text('Sign Out', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Auth().signOut();
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
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/page.png'), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text('Main Page', style: TextStyle(fontSize: 24)),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
