import 'package:flutter/material.dart';
import 'stock_detail_page.dart';
import 'snp500card.dart';

// MarketCard 위젯
class MarketCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final Color color;

  const MarketCard({
    required this.title,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Text(
          change,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}

// Index 페이지
class IndexPage extends StatelessWidget {
  final bool isLoggedIn;

  IndexPage({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Stock Invest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              SP500Card(),
              SizedBox(height: 20),

              // 섹션 2: 차트
              Text(
                "Your Portfolio",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    leading: Icon(Icons.pie_chart, color: Colors.blue),
                    title: Text(
                      'Portfolio Value: \$12,553.70',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Growth: +25.54%',
                      style: TextStyle(color: Colors.green),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.white),
                    onTap: () {
                      // 클릭 시 포트폴리오 상세 보기
                    },
                  )),
              SizedBox(height: 20),

              // 섹션 3: 즐겨찾기
              Text(
                "Favorites",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.grey[850],
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.yellow),
                      title: Text(
                        'Apple (AAPL)',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Price: \$178.34',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.white),
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.yellow),
                      title: Text(
                        'Tesla (TSLA)',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Price: \$725.50',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
