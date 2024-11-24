import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockChart extends StatefulWidget {
  final List<Map<String, dynamic>> stockData;

  StockChart({required this.stockData});

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  String hoveredDate = ""; // 호버된 날짜
  String hoveredPrice = ""; // 호버된 가격

  @override
  Widget build(BuildContext context) {
    // 데이터를 그래프 포인트로 변환
    List<FlSpot> spots = widget.stockData.asMap().entries.map((entry) {
      int index = entry.key;
      double closePrice = entry.value['Close'];
      return FlSpot(index.toDouble(), closePrice);
    }).toList();

    return Column(
      children: [
        if (hoveredDate.isNotEmpty && hoveredPrice.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Date: $hoveredDate, Price: $hoveredPrice",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: widget.stockData.length > 10
                          ? widget.stockData.length / 10
                          : 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= widget.stockData.length)
                          return Container();
                        String date =
                            widget.stockData[index]['Date'].split(' ')[0];
                        return Text(date, style: TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: spots,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false), // 데이터 포인트 표시
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        int index = spot.x.toInt();
                        String date =
                            widget.stockData[index]['Date'].split(' ')[0];
                        String price = spot.y.toStringAsFixed(2);
                        return LineTooltipItem(
                          "Date: $date\nPrice: $price",
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (response != null &&
                        response.lineBarSpots != null &&
                        response.lineBarSpots!.isNotEmpty) {
                      final spot = response.lineBarSpots!.first;
                      final index = spot.x.toInt();
                      setState(() {
                        hoveredDate =
                            widget.stockData[index]['Date'].split(' ')[0];
                        hoveredPrice = spot.y.toStringAsFixed(2);
                      });
                    } else {
                      setState(() {
                        hoveredDate = "";
                        hoveredPrice = "";
                      });
                    }
                  },
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
