import 'package:http/http.dart' as http;
import 'dart:convert';

class StockService {
  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final response = await http.get(Uri.parse('API_URL/$symbol'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stock data');
    }
  }
}
