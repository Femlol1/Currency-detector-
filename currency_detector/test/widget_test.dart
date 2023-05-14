// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:currency_detector/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_detector/main.dart';
import 'package:provider/provider.dart';
import 'package:currency_detector/theme.dart';

void main() {
  testWidgets('CurrencyDetectorApp runs and shows Auth widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeModel(),
        child: CurrencyDetectorApp(),
      ),
    );

    // Expect to find the Auth widget
    expect(find.byType(Auth), findsOneWidget);
  });
  testWidgets('SwipeNavigation displays correct AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeModel(),
        child: MaterialApp(home: SwipeNavigation()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Currency Guru'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  //Test the MainPage widget to see if it displays the correct text and button
  testWidgets('MainPage displays correct content', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MainPage()));

    expect(find.text('Main Page'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
