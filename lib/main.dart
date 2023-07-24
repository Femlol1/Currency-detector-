import 'package:currency_detector/authentication/auth.dart';
import 'package:currency_detector/currencyDetection/cd.dart';
import 'package:currency_detector/currencyDetection/cdrealtime.dart';
import 'package:currency_detector/currencyDetection/conversionpage.dart';
import 'package:currency_detector/settings/settings.dart';
import 'package:currency_detector/settings/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'authentication/firebase_options.dart';

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
      ChangeNotifierProvider(
        create: (_) => LanguageModel(),
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
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('es', ''), // Spanish
          // add more locales here
        ],
        localizationsDelegates: [
          // this line is important
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
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

// this class allows the navigation of the pages in the app through swipes

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
  final FlutterTts flutterTts = FlutterTts();

  void _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeModel>(context).textSize;

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32),
              ),
              Text(
                '*To use the app, click the Settings button to adjust the preferences.\n '
                '*To use currency detection swipe to the left 2 TIMES to view the currency detection page\n'
                '*To hear the instructions aloud, click the Text-to-Speech button.',
                style: TextStyle(
                  fontSize: textSize,
                  //fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Color.fromARGB(255, 210, 25, 34),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
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
                  ElevatedButton(
                    onPressed: () {
                      _speak(
                          'To use the app, click the Settings button to adjust the preferences.\n'
                          'To use currency detection swipe to the left 2 TIMES to view the currency detection page\n');
                    },
                    child: Text(
                      'Speak',
                      style: TextStyle(fontSize: textSize),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
