import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/providers/auth_provider.dart'; // AuthProvider 가져오기

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

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
      // 백엔드 API 호출로 즐겨찾기 목록 가져오기
      // 예시: API에서 데이터 가져오기
      // final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/favorites/"),
      //     headers: {"Authorization": "Bearer ${authProvider.token}"});

      // 아래는 테스트 데이터를 사용하는 코드
      await Future.delayed(const Duration(seconds: 1)); // 가상 대기 시간
      setState(() {
        favoriteStocks = [
          {"ticker": "AAPL", "name": "Apple Inc.", "price": 178.34},
          {"ticker": "TSLA", "name": "Tesla Inc.", "price": 725.50},
        ];
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

  Future<void> addFavoriteStock(String ticker, String name) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites.')),
      );
      return;
    }

    try {
      // 백엔드 API에 즐겨찾기 추가 요청
      // 예시: await http.post(Uri.parse("http://127.0.0.1:8000/api/favorites/"),
      //     headers: {"Authorization": "Bearer ${authProvider.token}"}, body: {"ticker": ticker});

      setState(() {
        favoriteStocks.add({"ticker": ticker, "name": name});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock added to favorites.')),
      );
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
      // 백엔드 API에 즐겨찾기 삭제 요청
      // 예시: await http.delete(Uri.parse("http://127.0.0.1:8000/api/favorites/$ticker"),
      //     headers: {"Authorization": "Bearer ${authProvider.token}"});

      setState(() {
        favoriteStocks.removeWhere((stock) => stock['ticker'] == ticker);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock removed from favorites.')),
      );
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
      return Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
          backgroundColor: Colors.black,
        ),
        body: Center(
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
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.black,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter stock ticker...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (ticker) {
                            addFavoriteStock(
                                ticker, "Sample Name"); // 간단한 추가 기능
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // 간단한 예: Apple 추가
                          addFavoriteStock("AAPL", "Apple Inc.");
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 목록
                Expanded(
                  child: favoriteStocks.isEmpty
                      ? const Center(
                          child: Text(
                            "No favorites added.",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: favoriteStocks.length,
                          itemBuilder: (context, index) {
                            final stock = favoriteStocks[index];
                            return Card(
                              child: ListTile(
                                title: Text(stock['name']),
                                subtitle: Text(
                                  "Ticker: ${stock['ticker']}, Price: \$${stock['price'].toStringAsFixed(2)}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () =>
                                      removeFavoriteStock(stock['ticker']),
                                ),
                                onTap: () {
                                  // TODO: 주식 상세 페이지로 이동
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
