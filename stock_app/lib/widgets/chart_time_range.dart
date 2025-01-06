import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';

class ChartTimeRangeWidget extends StatefulWidget {
  final List<CandleData> candleData;
  final Function(String)? onRangeSelected;

  const ChartTimeRangeWidget({
    Key? key,
    required this.candleData,
    this.onRangeSelected,
  }) : super(key: key);

  @override
  _ChartTimeRangeWidgetState createState() => _ChartTimeRangeWidgetState();
}

class _ChartTimeRangeWidgetState extends State<ChartTimeRangeWidget> {
  String selectedRange = "1 Day";

  final List<String> timeRanges = [
    "1 Day",
    "5 Days",
    "1 Month",
    "6 Month",
    "1 Year",
    "5 Years",
    "10 Years",
    "Max"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기간 선택 버튼
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: timeRanges.map((range) {
                final isSelected = range == selectedRange;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRange = range; // 선택 변경
                    });
                    if (widget.onRangeSelected != null) {
                      widget.onRangeSelected!(range); // 부모에게 선택 값 전달
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey),
                    ),
                    child: Text(
                      range,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
