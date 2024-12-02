import 'package:flutter/material.dart';

class StockInfoWidget extends StatelessWidget {
  final Map<String, dynamic> stockData;

  const StockInfoWidget({Key? key, required this.stockData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stockData['longName'] ?? 'Unknown Company',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Industry: ${stockData['industry'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Sector: ${stockData['sector'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Current Price: \$${stockData['currentPrice'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
