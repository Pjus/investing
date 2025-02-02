class Stock {
  final String symbol;
  final String name;
  final double price;

  Stock({required this.symbol, required this.name, required this.price});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
