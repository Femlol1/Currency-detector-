import 'package:flutter/material.dart';
import 'api_service.dart';

class ConversionPage extends StatefulWidget {
  final String baseCurrency;
  ConversionPage({required this.baseCurrency});

  @override
  ConversionPageState createState() => ConversionPageState();
}

class ConversionPageState extends State<ConversionPage> {
  late Future<Map<String, dynamic>> futureRates;

  @override
  void initState() {
    super.initState();
    futureRates = ApiService().fetchExchangeRates(widget.baseCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Conversion'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: futureRates,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!['rates'].length,
                itemBuilder: (context, index) {
                  var currency = snapshot.data!['rates'].keys.elementAt(index);
                  var rate = snapshot.data!['rates'][currency];
                  return ListTile(
                    title: Text('$currency: $rate'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
