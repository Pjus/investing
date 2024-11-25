import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChartDetailPage extends StatefulWidget {
  final String ticker; // 종목 티커 (예: "AAPL")

  ChartDetailPage({required this.ticker});

  @override
  _ChartDetailPageState createState() => _ChartDetailPageState();
}

class _ChartDetailPageState extends State<ChartDetailPage> {
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
            'http://127.0.0.1:8000/api/stocks/${widget.ticker}/'), // Django API 호출
        headers: {'Content-Type': 'application/json'},
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
          SnackBar(content: Text('Failed to fetch stock data')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticker),
        backgroundColor: Colors.black,
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
                        // 종목 정보 섹션
                        Text(
                          stockData!['name'] ?? 'Unknown Company',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          stockData!['description'] ??
                              'No description available',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 16),

                        // 가격 및 변동 정보
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${stockData!['price'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${stockData!['change']}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: stockData!['change'] >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Text(
                                  'Post: ${stockData!['postChange']}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: stockData!['postChange'] >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // 차트 섹션 (샘플 데이터)
                        Container(
                          height: 200,
                          color: Colors.grey[900], // 차트 배경색
                          child: Center(
                            child: Text(
                              'Chart Placeholder',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // 추가 정보
                        Divider(color: Colors.grey),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Market Cap: ${stockData!['marketCap']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Volume: ${stockData!['volume']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'P/E Ratio: ${stockData!['peRatio']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
    );
  }
}
