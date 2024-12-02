import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interactive_chart/interactive_chart.dart';
import 'dart:convert';
import 'package:stock_app/screens/widgets/additional_info_widget.dart';
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<CandleData> _getCandleData() {
    if (stockData == null || stockData!['data'] == null) return [];

    final data = stockData!['data'] as List<dynamic>;
    return data.map((entry) {
      return CandleData(
        timestamp: DateTime.parse(entry['Date']).millisecondsSinceEpoch,
        open: (entry['Open'] as num?)?.toDouble(),
        high: (entry['High'] as num?)?.toDouble(),
        low: (entry['Low'] as num?)?.toDouble(),
        close: (entry['Close'] as num?)?.toDouble(),
        volume: (entry['Volume'] as num?)?.toDouble(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final candleData = _getCandleData();

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
                          'Candlestick Chart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 500,
                          child: InteractiveChart(
                            candles: candleData,
                            style: ChartStyle(
                              priceGainColor: Colors.green,
                              priceLossColor: Colors.red,
                              volumeColor: Colors.blue.withOpacity(0.5),
                              trendLineStyles: [
                                Paint()
                                  ..strokeWidth = 2.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.orange,
                              ],
                              selectionHighlightColor:
                                  Colors.blue.withOpacity(0.2),
                              overlayBackgroundColor:
                                  Colors.black.withOpacity(0.7),
                              overlayTextStyle: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                              volumeHeightFactor: 0.2,
                            ),
                            overlayInfo: (candle) => {
                              "Open": "${candle.open?.toStringAsFixed(2)}",
                              "High": "${candle.high?.toStringAsFixed(2)}",
                              "Low": "${candle.low?.toStringAsFixed(2)}",
                              "Close": "${candle.close?.toStringAsFixed(2)}",
                              "Volume": "${candle.volume?.toStringAsFixed(2)}",
                            },
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
