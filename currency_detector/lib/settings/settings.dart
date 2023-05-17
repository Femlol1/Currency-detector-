import 'package:currency_detector/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeModel>(context).textSize;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: textSize)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 16),
            Text('Text size: ${textSize.toStringAsFixed(0)}',
                style: TextStyle(fontSize: textSize)),
            Slider(
              min: 12.0,
              max: 36.0,
              divisions: 12,
              value: textSize,
              onChanged: (value) {
                Provider.of<TextSizeModel>(context, listen: false)
                    .setTextSize(value);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<ThemeModel>(context, listen: false).toggleTheme();
              },
              child: Text(
                'Toggle Theme',
                style: TextStyle(fontSize: textSize),
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
                  style: TextStyle(fontSize: textSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
