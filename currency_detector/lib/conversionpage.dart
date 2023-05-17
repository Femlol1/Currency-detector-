import 'package:currency_detector/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:currency_detector/text_size_model.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  CurrencyConverterPageState createState() => CurrencyConverterPageState();
}

class CurrencyConverterPageState extends State<CurrencyConverterPage> {
  String fromCurrency = "USD";
  String toCurrency = "EUR";
  double conversionRate = 0.85; // 1 USD to EUR as of the time of writing
  double fromValue = 1.0;
  double toValue = 0.92;

  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeModel>(context).textSize;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount in $fromCurrency',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  fromValue = double.tryParse(value) ?? 0.0;
                  toValue = fromValue * conversionRate;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              '$fromValue $fromCurrency = $toValue $toCurrency',
              style: TextStyle(fontSize: textSize),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // switch currencies
                setState(() {
                  String tempCurrency = fromCurrency;
                  fromCurrency = toCurrency;
                  toCurrency = tempCurrency;

                  double tempValue = fromValue;
                  fromValue = toValue;
                  toValue = tempValue;

                  conversionRate = 1 / conversionRate;
                });
              },
              child: Text(
                'Switch Currencies',
                style: TextStyle(fontSize: textSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
