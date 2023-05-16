import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final apiKey = dotenv.env['API_KEY'];

  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse(
        'http://data.fixer.io/api/latest?access_key=$apiKey&base=$baseCurrency'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
