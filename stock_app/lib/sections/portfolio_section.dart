import 'package:flutter/material.dart';
import '../utils/utils.dart'; // formatNumber 함수

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.star, color: Colors.yellow),
            title: Text(
              'Portfolio Value : ${formatNumber(13000000)}',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Price: \$725.50',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
