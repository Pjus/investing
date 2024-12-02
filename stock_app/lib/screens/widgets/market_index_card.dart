import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../stock_detail_page.dart'; // 디테일 페이지

class MarketIndexCard extends StatefulWidget {
  final String title; // 예: S&P 500, Dow Jones
  final String symbol; // 예: ^GSPC, ^DJI
  final String apiUrl; // 예: http://127.0.0.1:8000/api/snp500/

  const MarketIndexCard({
    required this.title,
    required this.symbol,
    required this.apiUrl,
    Key? key,
  }) : super(key: key);

  @override
  _MarketIndexCardState createState() => _MarketIndexCardState();
}

class _MarketIndexCardState extends State<MarketIndexCard> {
  Map<String, dynamic>? indexData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIndexData();
  }

  Future<void> fetchIndexData() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          indexData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch ${widget.title} data')),
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
            ? const Text(
                'Loading...',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                '${widget.title}: ${indexData?['last_close']} (${indexData?['change_percent']}%)',
                style: TextStyle(color: Colors.white),
              ),
        subtitle: isLoading
            ? null
            : Text(
                'Day Range: ${indexData?['day_range']}',
                style: TextStyle(color: Colors.grey),
              ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          // 디테일 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailPage(symbol: widget.symbol),
            ),
          );
        },
      ),
    );
  }
}