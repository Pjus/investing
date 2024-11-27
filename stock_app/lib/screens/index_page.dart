import 'package:flutter/material.dart';
import 'stock_detail_page.dart';
import 'market_index_page.dart';
import 'news_page.dart';

// Index 페이지
class IndexPage extends StatelessWidget {
  final bool isLoggedIn;

  const IndexPage({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 섹션 1: 실시간 데이터
                    const Text(
                      "Index",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MarketIndexPage(),
                    const SizedBox(height: 20),

                    // 섹션 2: 차트
                    const Text(
                      "Your Portfolio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // 포트폴리오 섹션: 로그인 여부에 따라 표시
                    if (isLoggedIn)
                      _buildPortfolioSection()
                    else
                      _buildLoginPrompt(context),

                    // 섹션 3: 즐겨찾기
                    const Text(
                      "Favorites",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.grey[850],
                      child: Column(
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.star, color: Colors.yellow),
                            title: const Text(
                              'Apple (AAPL)',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Price: \$178.34',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.white),
                            onTap: () {
                              // 디테일 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StockDetailPage(symbol: 'AAPL'),
                                ),
                              );
                            },
                          ),
                          const Divider(color: Colors.grey),
                          ListTile(
                            leading:
                                const Icon(Icons.star, color: Colors.yellow),
                            title: const Text(
                              'Tesla (TSLA)',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Price: \$725.50',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.white),
                            onTap: () {
                              // 디테일 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StockDetailPage(symbol: 'TSLA'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 섹션 4: 뉴스
                    const Text(
                      "News",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NewsList(), // 뉴스 섹션
        ),
      ),
    );
  }
}

// 포트폴리오 섹션 (로그인 상태에서만 표시)
Widget _buildPortfolioSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Portfolio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Here is a summary of your portfolio data.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

// 로그인 유도 섹션 (비로그인 상태에서만 표시)
Widget _buildLoginPrompt(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Log in to view your portfolio.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
            },
            child: const Text('Log In'),
          ),
          const SizedBox(width: 20), // 버튼 사이의 공간 (여기서 조정)
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup'); // 로그인 페이지로 이동
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    ],
  );
}
