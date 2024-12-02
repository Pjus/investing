import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PriceChartWidget extends StatelessWidget {
  final Map<String, dynamic> stockData;
  final List<FlSpot> spots;
  final double interval;

  const PriceChartWidget({
    Key? key,
    required this.stockData,
    required this.spots,
    required this.interval,
  }) : super(key: key);

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    final data = stockData['data'] as List<dynamic>;
    DateTime startDate = DateTime.parse(data.first['Date']);
    DateTime date = startDate.add(Duration(days: value.toInt()));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        DateFormat('MM/dd').format(date),
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    if (value % 5 != 0) return const SizedBox.shrink();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          '${value.toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              getTitlesWidget: _buildBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _buildLeftTitles,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
