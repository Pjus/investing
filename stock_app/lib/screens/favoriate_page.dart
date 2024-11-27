import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

Future<List<Map<String, String>>> loadNasdaqData() async {
  final rawData = await rootBundle.loadString('assets/nasdaq.csv'); // 파일 경로
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

  // 헤더 추출
  final headers = csvTable.first.map((e) => e.toString()).toList();

  // 데이터를 Map 형식으로 변환
  List<Map<String, String>> data = csvTable
      .skip(1) // 첫 번째 행은 헤더이므로 제외
      .map((row) => Map<String, String>.fromIterables(
          headers, row.map((e) => e.toString())))
      .toList();

  return data;
}

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, String>> allStocks = []; // 전체 주식 데이터
  List<Map<String, String>> filteredStocks = []; // 검색 결과
  List<Map<String, String>> favoriteStocks = []; // 즐겨찾기 목록

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStockData();
  }

  Future<void> loadStockData() async {
    try {
      final data = await loadNasdaqData();
      setState(() {
        allStocks = data;
        filteredStocks = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stock data: $e')),
      );
    }
  }

  void searchStocks(String query) {
    setState(() {
      filteredStocks = allStocks
          .where((stock) =>
              stock['ticker']!.toLowerCase().contains(query.toLowerCase()) ||
              stock['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleFavorite(Map<String, String> stock) {
    setState(() {
      if (favoriteStocks.contains(stock)) {
        favoriteStocks.remove(stock);
      } else {
        favoriteStocks.add(stock);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Favorites'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // 검색 입력 필드
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search stocks...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: searchStocks,
                  ),
                ),
                // 검색 결과 리스트
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = filteredStocks[index];
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text(
                            stock['ticker']!, // 티커
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            stock['name']!, // 회사 이름
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              favoriteStocks.contains(stock)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteStocks.contains(stock)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => toggleFavorite(stock),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
