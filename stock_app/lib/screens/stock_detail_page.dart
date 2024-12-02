import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:stock_app/screens/widgets/additional_info_widget.dart';
import 'package:stock_app/screens/widgets/price_chart_widget.dart';
import 'package:stock_app/screens/widgets/stock_info_widget.dart';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  const StockDetailPage({Key? key, required this.symbol}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  Map<String, dynamic>? stockData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/stock/${widget.symbol}/?period=1y&interval=1d'),
      );

      if (response.statusCode == 200) {
        setState(() {
          stockData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('Failed to fetch data');
      }
    } catch (error) {
      _showErrorSnackBar('Error: $error');
    }
  }

  void _showErrorSnackBar(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  List<FlSpot> _getChartSpots() {
    if (stockData == null || stockData!['data'] == null) return [];

    final data = stockData!['data'] as List<dynamic>;
    DateTime startDate = DateTime.parse(data.first['Date']);

    return data.map((entry) {
      final date = DateTime.parse(entry['Date']);
      final closePrice = (entry['Close'] as num?)?.toDouble() ?? 0.0;
      return FlSpot(date.difference(startDate).inDays.toDouble(), closePrice);
    }).toList();
  }

  double _calculateInterval(BuildContext context, int dataLength) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return dataLength / 2; // Small screens
    } else if (screenWidth < 800) {
      return dataLength / 5; // Medium screens
    } else {
      return dataLength / 8; // Large screens
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getChartSpots();
    final interval = _calculateInterval(context, spots.length);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockData != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StockInfoWidget(stockData: stockData!),
                        const SizedBox(height: 20),
                        const Text(
                          'Price Chart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          child: PriceChartWidget(
                            stockData: stockData!,
                            spots: spots,
                            interval: interval,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AdditionalInfoWidget(stockData: stockData!),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No data available')),
    );
  }
}
