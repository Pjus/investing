import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interactive_chart/interactive_chart.dart';
import 'dart:convert';
import 'package:stock_app/screens/widgets/additional_info_widget.dart';
import 'package:stock_app/screens/widgets/stock_info_widget.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/screens/utils/dark_mode_provider.dart';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  const StockDetailPage({super.key, required this.symbol});

  @override
  // ignore: library_private_types_in_public_api
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  Map<String, dynamic>? stockData;
  final ScrollController _scrollController = ScrollController();

  bool _disableScroll = false;
  bool _isPointerInsideChart = false; // 차트 내부 상태 추적
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
            'http://127.0.0.1:8000/api/stock/${widget.symbol}/?period=1y&interval=1d'),
      );

      if (response.statusCode == 200) {
        setState(() {
          stockData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('Failed to fetch data');
      }
    } catch (error) {
      _showErrorSnackBar('Error: $error');
    }
  }

  void _showErrorSnackBar(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<CandleData> _getCandleData() {
    if (stockData == null || stockData!['data'] == null) return [];

    final data = stockData!['data'] as List<dynamic>;
    return data.map((entry) {
      return CandleData(
        timestamp: DateTime.parse(entry['Date']).millisecondsSinceEpoch,
        open: (entry['Open'] as num?)?.toDouble(),
        high: (entry['High'] as num?)?.toDouble(),
        low: (entry['Low'] as num?)?.toDouble(),
        close: (entry['Close'] as num?)?.toDouble(),
        volume: (entry['Volume'] as num?)?.toDouble(),
      );
    }).toList();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && _isPointerInsideChart) {
      // 차트 영역 내부에서만 줌 동작 처리
      setState(() {
        _disableScroll = true;
      });
    } else {
      // 차트 영역 밖에서 스크롤 복구
      setState(() {
        _disableScroll = false;
      });
    }
  }

  bool _showAverage = false;

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    final candleData = _getCandleData();

    computeTrendLines() {
      final ma7 = CandleData.computeMA(candleData, 7);
      final ma30 = CandleData.computeMA(candleData, 30);
      final ma90 = CandleData.computeMA(candleData, 90);

      for (int i = 0; i < candleData.length; i++) {
        candleData[i].trends = [ma7[i], ma30[i], ma90[i]];
      }
    }

    removeTrendLines() {
      for (final data in candleData) {
        data.trends = [];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        // actions: [
        //   IconButton(
        //     icon: Icon(darkModeProvider.isDarkMode
        //         ? Icons.dark_mode
        //         : Icons.light_mode),
        //     onPressed: () {
        //       darkModeProvider.toggleDarkMode();
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       _showAverage ? Icons.show_chart : Icons.bar_chart_outlined,
        //     ),
        //     onPressed: () {
        //       setState(() => _showAverage = !_showAverage);
        //       if (_showAverage) {
        //         computeTrendLines();
        //       } else {
        //         removeTrendLines();
        //       }
        //     },
        //   ),
        // ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockData != null
              ? NotificationListener(
                  onNotification: (PointerSignalEvent event) {
                    _handlePointerSignal(event); // 모든 PointerSignalEvent 감지
                    return true;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: _disableScroll
                        ? const NeverScrollableScrollPhysics() // 스크롤 비활성화
                        : const BouncingScrollPhysics(), //
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StockInfoWidget(stockData: stockData!),
                          const SizedBox(height: 20),
                          const Text(
                            'Candlestick Chart',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _isPointerInsideChart = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _isPointerInsideChart = false;
                                _disableScroll = false; // 차트 외부로 나가면 스크롤 복구
                              });
                            },
                            child: Listener(
                              onPointerSignal: _handlePointerSignal,
                              child: SizedBox(
                                height: 500,
                                child: InteractiveChart(
                                  candles: candleData, // 최신 데이터 전달
                                  style: ChartStyle(
                                    priceGainColor: Colors.green,
                                    priceLossColor: Colors.red,
                                    volumeColor: Colors.blue.withOpacity(0.5),
                                    selectionHighlightColor:
                                        Colors.blue.withOpacity(0.2),
                                    overlayBackgroundColor:
                                        Colors.black.withOpacity(0.7),
                                    overlayTextStyle: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    volumeHeightFactor: 0.2,
                                  ),
                                  overlayInfo: (candle) => {
                                    "Open":
                                        "${candle.open?.toStringAsFixed(2)}",
                                    "High":
                                        "${candle.high?.toStringAsFixed(2)}",
                                    "Low": "${candle.low?.toStringAsFixed(2)}",
                                    "Close":
                                        "${candle.close?.toStringAsFixed(2)}",
                                    "Volume": "${candle.volume}",
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          AdditionalInfoWidget(stockData: stockData!),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('No data available')),
    );
  }
}
