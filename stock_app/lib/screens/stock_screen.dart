import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stock_chart.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _symbolController = TextEditingController();

  // Period 버튼 목록
  final List<String> periods = [
    "1d",
    "5d",
    "1mo",
    "3mo",
    "6mo",
    "1y",
    "2y",
    "5y",
    "10y",
    "ytd",
    "max"
  ];

  // Interval 옵션
  final Map<String, List<String>> intervalsByPeriod = {
    "1d": ["1m", "5m", "15m", "30m", "1h"], // 분 단위
    "5d": ["1h", "1d"], // 시간 및 일 단위
    "default": ["1d", "1wk", "1mo", "1y"] // 일, 주, 월, 연 단위
  };

  String selectedPeriod = "1d"; // 선택된 period
  String selectedInterval = "1m"; // 선택된 interval
  List<Map<String, dynamic>> _stockData = [];
  bool _isLoading = false;

  // 현재 period에 맞는 interval 버튼 목록 반환
  List<String> get intervals {
    if (selectedPeriod == "1d") {
      return intervalsByPeriod["1d"]!;
    } else if (selectedPeriod == "5d") {
      return intervalsByPeriod["5d"]!;
    } else {
      return intervalsByPeriod["default"]!;
    }
  }

  Future<void> _fetchStockData() async {
    final String symbol = _symbolController.text;

    if (symbol.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a stock symbol")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/api/stock/$symbol/?period=$selectedPeriod&interval=$selectedInterval'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _stockData = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Data Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _symbolController,
              decoration: InputDecoration(
                labelText: 'Stock Symbol',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('Select Period:'),
            Wrap(
              spacing: 8.0,
              children: periods.map((period) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPeriod = period;
                      // period 변경 시 interval 초기화
                      selectedInterval = intervals.first;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedPeriod == period ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white, // 텍스트 색상 설정
                  ),
                  child: Text(period),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('Select Interval:'),
            Wrap(
              alignment: WrapAlignment.center, // 가로 정렬
              crossAxisAlignment: WrapCrossAlignment.center, // 세로 정렬
              spacing: 8.0,
              children: intervals.map((interval) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedInterval = interval;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedInterval == interval
                        ? Colors.blue
                        : Colors.grey,
                    foregroundColor: Colors.white, // 텍스트 색상 설정
                  ),
                  child: Text(interval),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchStockData,
              child: Text('Fetch Stock Data'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _stockData.isNotEmpty
                    ? Expanded(child: StockChart(stockData: _stockData))
                    : Text('No data available'),
          ],
        ),
      ),
    );
  }
}
