import 'package:flutter/material.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  // 샘플 데이터: 티커, 기업 이름, 가격, 즐겨찾기 상태
  final List<Map<String, dynamic>> stocks = [
    {
      "ticker": "AAPL",
      "name": "Apple Inc.",
      "price": 178.23,
      "isFavorite": false
    },
    {
      "ticker": "GOOGL",
      "name": "Alphabet Inc.",
      "price": 2813.67,
      "isFavorite": true
    },
    {
      "ticker": "AMZN",
      "name": "Amazon.com Inc.",
      "price": 3421.45,
      "isFavorite": false
    },
    {
      "ticker": "MSFT",
      "name": "Microsoft Corp.",
      "price": 299.35,
      "isFavorite": true
    },
    {
      "ticker": "TSLA",
      "name": "Tesla Inc.",
      "price": 725.23,
      "isFavorite": false
    },
    {
      "ticker": "META",
      "name": "Meta Platforms Inc.",
      "price": 248.19,
      "isFavorite": false
    },
  ];

  void toggleFavorite(int index) {
    setState(() {
      stocks[index]['isFavorite'] = !stocks[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Charts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: stocks.length,
          itemBuilder: (context, index) {
            final stock = stocks[index];
            return Card(
              color: Colors.grey[850],
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    stock['ticker'][0], // 티커 이름의 첫 글자
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stock['ticker'], // 티커 이름
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${stock['price'].toStringAsFixed(2)}', // 가격
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                subtitle: Text(
                  stock['name'], // 기업 이름
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(
                    stock['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: stock['isFavorite'] ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => toggleFavorite(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
