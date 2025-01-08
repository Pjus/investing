import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/providers/favorites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteStocks = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    favoritesProvider.fetchAllStocks(context); // 전체 데이터를 초기화
    favoritesProvider.fetchFavorites(context); // 전체 데이터를 초기화
  }

  void addFavorite(String ticker) {
    // Add favorite logic
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    favoritesProvider.addFavorite(context, ticker, "Sample Name");
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    // 즐겨찾기 정렬 및 중복 제거
    List<Map<String, dynamic>> sortedStocks = [
      ...{...favoritesProvider.favorites}, // 즐겨찾기 리스트 중복 제거
      ...{
        ...favoritesProvider.allStocks.where(
          (stock) => !favoritesProvider.favorites.any(
            (favorite) =>
                (favorite['ticker']?.toLowerCase() ?? '') ==
                (stock['ticker']?.toLowerCase() ?? ''),
          ),
        ),
      }, // 비즐겨찾기 리스트 중복 제거
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 상단 검색창과 플러스 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter a ticker (e.g., AAPL)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        favoritesProvider.filterFavorites, // 검색어 변경 시 필터링
                    onSubmitted: (value) {
                      // 검색 또는 추가 실행
                      addFavorite(value.trim());
                      _searchController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    // 플러스 버튼 눌렀을 때
                    final ticker = _searchController.text.trim();
                    if (ticker.isNotEmpty) {
                      addFavorite(ticker);
                      _searchController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          // 전체 목록
          Expanded(
              child: favoritesProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: favoritesProvider.allStocks.length,
                      itemBuilder: (context, index) {
                        final stock = sortedStocks[index];
                        final isFavorite =
                            favoritesProvider.favorites.any((favorite) {
                          final favoriteTicker =
                              favorite['ticker']?.toLowerCase() ?? '';
                          final stockTicker =
                              stock['ticker']?.toLowerCase() ?? '';
                          return favoriteTicker == stockTicker;
                        }); // 즐겨찾기 여부 확인
                        return Card(
                          child: ListTile(
                            title: Text(
                                stock['ticker']?.toUpperCase() ?? 'Unknown'),
                            subtitle: Text("${stock['name']}".toUpperCase()),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  // 즐겨찾기에서 제거
                                  favoritesProvider.removeFavorite(
                                      context, stock['ticker']);
                                } else {
                                  // 즐겨찾기에 추가
                                  favoritesProvider.addFavorite(
                                      context, stock['ticker'], stock['name']);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
