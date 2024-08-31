import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// ApiService is responsible for fetching data from a specific API.
class ApiService {
  // It uses an API key stored in the environment variables.
  final apiKey = dotenv.env['API_KEY'];

  // fetchExchangeRates method fetches the exchange rates for a specified base currency.
  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    // It sends a GET request to the Fixer API, including the API key and base currency in the URL.
    final response = await http.get(Uri.parse(
        'http://data.fixer.io/api/latest?access_key=$apiKey&base=$baseCurrency'));

    // If the response is successful (status code 200), it decodes the JSON body and returns it as a map.
    // If the response is not successful, it throws an exception.
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}

// CurrencyRatesModel is a ChangeNotifier that fetches and manages currency rates data.
class CurrencyRatesModel extends ChangeNotifier {
  // It uses a service to fetch the rates.
  final CurrencyRateService _currencyRateService;
  // Stores the currency rates fetched from the service.
  late Map<String, double> _rates;

  // The constructor takes the service as an argument.
  CurrencyRatesModel(this._currencyRateService);

  // fetchRates method fetches the rates for the Euro currency and stores them in the _rates field.
  Future<void> fetchRates() async {
    _rates = await _currencyRateService.fetchRates('EUR');
    // It then notifies any listeners about this change.
    notifyListeners();
  }

  // getConversionRate method calculates and returns the conversion rate between two currencies.
  double? getConversionRate(String fromCurrency, String toCurrency) {
    if (_rates == null) {
      return null;
    }
    return _rates[toCurrency]! / _rates[fromCurrency]!;
  }
}

// CurrencyRateService is responsible for fetching currency rates data from the Fixer API.
class CurrencyRateService {
  // fetchRates method fetches the rates for a specified base currency.
  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    // It sends a GET request to the Fixer API, including the base currency in the URL.
    final response = await http.get(
        'http://data.fixer.io/api/latest?access_key=YOUR_ACCESS_KEY&base=$baseCurrency'
            as Uri);

    // If the response is successful (status code 200), it decodes the JSON body and extracts the rates as a map.
    // If the response is not successful, it throws an exception.
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      return Map<String, double>.from(json["rates"]);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load currency rates');
    }
  }
}
