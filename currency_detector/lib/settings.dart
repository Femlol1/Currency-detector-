import 'package:currency_detector/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Settings Page', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Provider.of<ThemeModel>(context, listen: false).toggleTheme();
              },
              child: Text(
                'Toggle Theme',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
