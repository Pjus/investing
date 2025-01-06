import 'package:flutter/material.dart';

class MarketIndexCard extends StatelessWidget {
  final String indexName;
  final double lastClose;
  final double changeNet;
  final double changePercent;
  final List<double> dayRange;

  const MarketIndexCard({
    super.key,
    required this.indexName,
    required this.lastClose,
    required this.changeNet,
    required this.changePercent,
    required this.dayRange,
  });

  @override
  Widget build(BuildContext context) {
    // 상승/하락 색상 선택
    final isPositive = changeNet > 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.trending_up,
          color: color,
        ),
        title: Text(
          "$indexName: ${lastClose.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${changeNet > 0 ? "+" : ""}${changeNet.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)",
              style: TextStyle(color: color),
            ),
            Text(
              "Day Range: ${dayRange[0].toStringAsFixed(2)} - ${dayRange[1].toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          // 상세 페이지 이동 등 추가 동작
        },
      ),
    );
  }
}
