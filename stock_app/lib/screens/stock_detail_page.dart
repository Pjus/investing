import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 차트 패키지 추가
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  StockDetailPage({required this.symbol});

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
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  List<FlSpot> _getChartSpots() {
    if (stockData == null || stockData!['data'] == null) return [];

    final data = stockData!['data'] as List<dynamic>;
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      double x = i.toDouble();
      double y =
          data[i]['Close'] != null ? (data[i]['Close'] as num).toDouble() : 0.0;
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : stockData != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 종목 기본 정보
                        Text(
                          stockData!['longName'] ?? 'Unknown Company',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Industry: ${stockData!['industry'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Sector: ${stockData!['sector'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Current Price: \$${stockData!['currentPrice'] ?? 'N/A'}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // 차트 섹션
                        Text(
                          'Price Chart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 300,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: const Color(0xff37434d),
                                  width: 1,
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _getChartSpots(),
                                  isCurved: true,
                                  barWidth: 2,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // 추가 정보
                        Divider(),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '52-Week High: \$${stockData!['fiftyTwoWeekHigh'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '52-Week Low: \$${stockData!['fiftyTwoWeekLow'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Market Cap: ${stockData!['marketCap'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Dividend Yield: ${stockData!['dividendYield'] ?? 'N/A'}%',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Beta: ${stockData!['beta'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text('No data available'),
                ),
    );
  }
}
