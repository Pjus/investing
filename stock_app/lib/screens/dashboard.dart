import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 금액 및 설명
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$12,553.70",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "+\$2,553.70 (25.54%)",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Hold a list of companies with an increasing profit margin from 2023 to 2024, over \$5 billion in revenue in Q3 2023, a profit margin of 60% or more, and are AI/Semiconductor stocks.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 차트와 기간 버튼
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        backgroundColor: Colors.black,
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          // 녹색 라인
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.green,
                            spots: [
                              const FlSpot(0, 10000),
                              const FlSpot(1, 10500),
                              const FlSpot(2, 11500),
                              const FlSpot(3, 12000),
                              const FlSpot(4, 12553),
                            ],
                          ),
                          // 회색 라인
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.grey,
                            spots: [
                              const FlSpot(0, 10000),
                              const FlSpot(1, 10200),
                              const FlSpot(2, 10800),
                              const FlSpot(3, 11000),
                              const FlSpot(4, 11200),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 기간 선택 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["2D", "1W", "1M", "6M", "1Y", "2Y", "5Y", "ALL"]
                        .map((e) => ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // 하단 요약 정보
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "02/19/2024",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Date",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "09/29/2024",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
