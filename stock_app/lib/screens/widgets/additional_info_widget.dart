import 'package:flutter/material.dart';
import 'package:stock_app/screens/utils/utils.dart';
import 'package:intl/intl.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final Map<String, dynamic> stockData;

  const AdditionalInfoWidget({Key? key, required this.stockData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
        // 날짜 변환 함수
    String formatTimestamp(dynamic timestamp) {
      if (timestamp == null) return 'N/A';
      // timestamp가 초 단위 Unix time이라고 가정
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
      return DateFormat('yyyy-MM-dd').format(date);
    }


    final overviewInfo = [
      _InfoItem(
        title: '52-Week Low - High',
        value:
            '${formatNumber(stockData['fiftyTwoWeekLow'])} - ${formatNumber(stockData['fiftyTwoWeekHigh'])}',
      ),
      _InfoItem(
        title: 'Market Cap',
        value: '\$${formatNumber(stockData['marketCap'])}',
      ),
      _InfoItem(title: 'Beta', value: '${stockData['beta']}'),
      _InfoItem(
          title: 'Previous Close', value: formatNumber(stockData['previousClose'])),
    ];

    final valuationInfo = [
      _InfoItem(title: 'Forward EPS', value: formatNumber(stockData['forwardEps'])),
      _InfoItem(title: 'Trailing PE', value: formatNumber(stockData['trailingPE'])),
      _InfoItem(title: 'Forward PE', value: formatNumber(stockData['forwardPE'])),
      _InfoItem(title: 'Price To Book', value: formatNumber(stockData['priceToBook'])),
    ];

    final financialsInfo = [
      _InfoItem(title: 'Total Revenue', value: '\$${formatNumber(stockData['totalRevenue'])}'),
      _InfoItem(title: 'Revenue/Share', value: formatNumber(stockData['revenuePerShare'])),
      _InfoItem(title: 'EBITDA', value: '\$${formatNumber(stockData['ebitda'])}'),
      _InfoItem(title: 'Operating Cashflow', value: '\$${formatNumber(stockData['operatingCashflow'])}'),
      _InfoItem(title: 'Free Cashflow', value: '\$${formatNumber(stockData['freeCashflow'])}'),
      _InfoItem(title: 'Total Debt', value: '\$${formatNumber(stockData['totalDebt'])}'),
      _InfoItem(title: 'Debt To Equity', value: '${formatNumber(stockData['debtToEquity'])}%'),
    ];

    final dividendsInfo = [
      _InfoItem(
          title: 'Dividend Yield',
          value: '${(stockData['dividendYield'] * 100).toStringAsFixed(2)}%'),
      _InfoItem(title: 'Dividend Rate', value: formatNumber(stockData['dividendRate'])),
      _InfoItem(
          title: 'Ex-Dividend Date',
          value: formatTimestamp(stockData['exDividendDate']).toString() ?? 'N/A'),
      _InfoItem(
          title: 'Last Dividend Value',
          value: formatNumber(stockData['lastDividendValue'])),
      _InfoItem(
          title: 'Last Dividend Date',
          value: formatTimestamp(stockData['lastDividendDate']).toString() ?? 'N/A'),
    ];

    // final growthInfo = [
    //   _InfoItem(
    //       title: 'Earnings Growth',
    //       value: '${(stockData['earningsGrowth'] * 100).toStringAsFixed(2)}%'),
    //   _InfoItem(
    //       title: 'Revenue Growth',
    //       value: '${(stockData['revenueGrowth'] * 100).toStringAsFixed(2)}%'),
    //   _InfoItem(
    //       title: 'Earnings Quarterly Growth',
    //       value:
    //           '${(stockData['earningsQuarterlyGrowth'] * 100).toStringAsFixed(2)}%'),
    //   _InfoItem(
    //       title: '52 Week Change',
    //       value: '${(stockData['52WeekChange'] * 100).toStringAsFixed(2)}%'),
    //   _InfoItem(
    //       title: 'Target Mean Price',
    //       value: '\$${formatNumber(stockData['targetMeanPrice'])}'),
    //   _InfoItem(
    //       title: 'Target High Price',
    //       value: '\$${formatNumber(stockData['targetHighPrice'])}'),
    //   _InfoItem(
    //       title: 'Target Low Price',
    //       value: '\$${formatNumber(stockData['targetLowPrice'])}'),
    // ];

    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Valuation'),
              Tab(text: 'Financials'),
              Tab(text: 'Dividends'),
              Tab(text: 'Growth'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300, // 원하는 높이 조정
            child: TabBarView(
              children: [
                _buildInfoGrid(overviewInfo),
                _buildInfoGrid(valuationInfo),
                _buildInfoGrid(financialsInfo),
                _buildInfoGrid(dividendsInfo),
                // _buildInfoGrid(growthInfo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
    Widget _buildInfoGrid(List<_InfoItem> infoItems) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3.5,
        ),
        itemCount: infoItems.length,
        itemBuilder: (context, index) {
          return _buildInfoTile(infoItems[index].title, infoItems[index].value);
        },
      ),
    );
  }


}



class _InfoItem {
  final String title;
  final String value;

  _InfoItem({required this.title, required this.value});
}
