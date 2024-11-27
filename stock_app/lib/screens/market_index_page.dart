import 'package:flutter/material.dart';
import 'market_index_card.dart'; // MarketIndexCard 위젯 정의 파일

const marketIndex = [
  MarketIndexCard(
    title: 'S&P 500',
    symbol: '^GSPC',
    apiUrl: 'http://127.0.0.1:8000/api/market/snp500/',
  ),
  MarketIndexCard(
    title: 'Dow Jones',
    symbol: '^DJI',
    apiUrl: 'http://127.0.0.1:8000/api/market/dowjones/',
  ),
  MarketIndexCard(
    title: 'Nasdaq',
    symbol: '^IXIC',
    apiUrl: 'http://127.0.0.1:8000/api/market/nasdaq/',
  ),
];

class MarketIndexPage extends StatelessWidget {
  const MarketIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 외부 스크롤과 충돌 방지
      itemCount: marketIndex.length,
      itemBuilder: (context, index) {
        final marketItem = marketIndex[index];
        return marketItem;
      },
    );
  }
}
