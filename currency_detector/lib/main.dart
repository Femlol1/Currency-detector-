import 'package:currency_detector/auth.dart';
import 'package:currency_detector/cd.dart';
import 'package:currency_detector/cdrealtime.dart';
import 'package:currency_detector/conversionpage.dart';
import 'package:currency_detector/settings.dart';
import 'package:currency_detector/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// The main entry point for the Flutter application.
Future<void> main() async {
  // Ensuring that the widget binding is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase with default options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Running the Flutter app with multiple providers to allow me to change the settings to appect all pages in the app.
  runApp(MultiProvider(
    providers: [
      // Adding a provider for the TextSizeModel.
      ChangeNotifierProvider(
        create: (context) => TextSizeModel(),
      ),
      // Adding a provider for the ThemeModel.
      ChangeNotifierProvider(
        create: (context) => ThemeModel(),
      ),
    ],
    // Specifying the root widget of the app, in this case CurrencyDetectorApp.
    child: CurrencyDetectorApp(),
  ));
}

// A stateless widget that represents the root of the app.
class CurrencyDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using a Consumer widget to listen for changes in the ThemeModel and rebuild the widget tree when it changes.
    return Consumer<ThemeModel>(
      builder: (context, theme, child) => MaterialApp(
        title: 'Currency Detector',
        // Defining the theme of the app based on the state of ThemeModel.
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        // Setting the initial page of the app to the result of handleAuthState function of Auth.
        home: Auth().handleAuthState(),
      ),
    );
  }
}

// this class asllows trhe navigation of the pages in the app through swipes

class SwipeNavigation extends StatefulWidget {
  @override
  SwipeNavigationState createState() => SwipeNavigationState();
}

class SwipeNavigationState extends State<SwipeNavigation> {
  // A controller for a page view widget.
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Guru'),
        actions: <Widget>[
          // A logout button that calls the signOut function of Auth when pressed.
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
      // A page view that allows horizontal swiping between pages.
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          // Defining the pages of the page view.
          MainPage(), // the main page
          CurrencyConverterPage(), // the currency convertion page
          CurrencyDetector(), // the currency detector pages
          CurrencyDetectorrealtime(),
        ],
      ),
    );
  }

  // Disposing of the page view controller when it is no longer needed.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeModel>(context).textSize;

    return Scaffold(
      body: Center(
        child: Container(
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
                    style: TextStyle(fontSize: textSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
