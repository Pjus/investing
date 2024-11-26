import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stock_detail_page.dart'; // 디테일 페이지

class SP500Card extends StatefulWidget {
  @override
  _SP500CardState createState() => _SP500CardState();
}

class _SP500CardState extends State<SP500Card> {
  Map<String, dynamic>? sp500Data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSP500Data();
  }

  Future<void> fetchSP500Data() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/snp500/'));

      if (response.statusCode == 200) {
        setState(() {
          sp500Data = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch S&P 500 data')),
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
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        leading: const Icon(Icons.show_chart, color: Colors.green),
        title: isLoading
            ? Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'S&P 500: ${sp500Data?['last_close']} (${sp500Data?['change_percent']}%)',
                style: TextStyle(color: Colors.white),
              ),
        subtitle: isLoading
            ? null
            : Text(
                'Day Range: ${sp500Data?['day_range']}',
                style: TextStyle(color: Colors.grey),
              ),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          // 디테일 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailPage(symbol: '^GSPC'),
            ),
          );
        },
      ),
    );
  }
}
