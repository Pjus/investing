import 'package:flutter/material.dart';
import 'package:stock_app/screens/utils/utils.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final Map<String, dynamic> stockData;

  const AdditionalInfoWidget({Key? key, required this.stockData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3.5,
      ),
      children: [
        _buildInfoTile('52-Week Low - High',
            '${formatNumber(stockData['fiftyTwoWeekLow'])} - ${formatNumber(stockData['fiftyTwoWeekHigh'])}'),
        _buildInfoTile(
            'Market Cap', '\$${formatNumber(stockData['marketCap'])}'),
        _buildInfoTile('Foward EPS', formatNumber(stockData['forwardEps'])),
        _buildInfoTile('Dividend Yield', '${stockData['dividendYield']}%'),
        _buildInfoTile('Beta', '${stockData['beta']}'),
      ],
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
}
