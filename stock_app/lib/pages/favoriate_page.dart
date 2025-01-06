import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/providers/auth_provider.dart'; // AuthProvider 가져오기

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteStocks = []; // 즐겨찾기 주식 목록
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavoriteStocks();
  }

  Future<void> fetchFavoriteStocks() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // TODO: 백엔드 API 호출로 즐겨찾기 목록 가져오기
      // 예: final response = await http.get(Uri.parse("API_URL"), headers: {"Authorization": "Bearer ${authProvider.token}"});
      setState(() {
        favoriteStocks = []; // 백엔드에서 가져온 데이터로 업데이트
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorites: $e')),
      );
    }
  }

  Future<void> searchStocks(String query) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to search stocks.')),
      );
      return;
    }

    try {
      // TODO: 백엔드 API 호출로 검색 결과 가져오기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  Future<void> addFavoriteStock(String ticker) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites.')),
      );
      return;
    }

    try {
      // TODO: 백엔드에 즐겨찾기 추가 요청
      // 예: await http.post(Uri.parse("API_URL"), body: {"ticker": ticker}, headers: {"Authorization": "Bearer ${authProvider.token}"});
      setState(() {
        favoriteStocks.add({"ticker": ticker, "name": "Sample Stock"});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add favorite: $e')),
      );
    }
  }

  Future<void> removeFavoriteStock(String ticker) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to remove favorites.')),
      );
      return;
    }

    try {
      // TODO: 백엔드에 즐겨찾기 삭제 요청
      setState(() {
        favoriteStocks.removeWhere((stock) => stock['ticker'] == ticker);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please log in to view your favorites.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Log In'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // 검색 입력 필드
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // 검색 입력 필드
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search stocks...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: searchStocks,
                        ),
                      ),
                      const SizedBox(width: 8), // 버튼과 간격
                      IconButton(
                        onPressed: () {
                          // TODO: Add stock logic
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 목록
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteStocks.length,
                    itemBuilder: (context, index) {
                      final stock = favoriteStocks[index];
                      return Card(
                        child: ListTile(
                          title: Text(stock['ticker'] ?? ''),
                          subtitle: Text(stock['name'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () =>
                                removeFavoriteStock(stock['ticker']!),
                          ),
                          onTap: () {
                            // TODO: 주식 차트 페이지로 이동
                          },
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
