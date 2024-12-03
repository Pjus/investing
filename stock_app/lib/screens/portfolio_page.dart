import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/screens/utils/auth_provider.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Map<String, dynamic>> portfolioStocks = []; // 포트폴리오 주식 목록
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPortfolioStocks();
  }

  Future<void> fetchPortfolioStocks() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/portfolio/"),
        headers: {"Authorization": "Bearer ${authProvider.token}"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          portfolioStocks = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch portfolio data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load portfolio: $e')),
      );
    }
  }

  Future<void> addStockToPortfolio(String ticker, double shares) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add stocks.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/portfolio/"),
        headers: {
          "Authorization": "Bearer ${authProvider.token}",
          "Content-Type": "application/json"
        },
        body: json.encode({"ticker": ticker, "shares": shares}),
      );

      if (response.statusCode == 201) {
        fetchPortfolioStocks(); // 포트폴리오 업데이트
      } else {
        throw Exception('Failed to add stock to portfolio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stock: $e')),
      );
    }
  }

  Future<void> removeStockFromPortfolio(String ticker) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await http.delete(
        Uri.parse("http://127.0.0.1:8000/api/portfolio/$ticker/"),
        headers: {"Authorization": "Bearer ${authProvider.token}"},
      );

      if (response.statusCode == 204) {
        fetchPortfolioStocks(); // 포트폴리오 업데이트
      } else {
        throw Exception('Failed to remove stock from portfolio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove stock: $e')),
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
              'Please log in to view your portfolio.',
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
      appBar: AppBar(
        title: const Text('Portfolio'),
        backgroundColor: Colors.grey[900],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: portfolioStocks.length,
                    itemBuilder: (context, index) {
                      final stock = portfolioStocks[index];
                      return Card(
                        child: ListTile(
                          title: Text(stock['ticker']),
                          subtitle: Text('Shares: ${stock['shares']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () =>
                                removeStockFromPortfolio(stock['ticker']),
                          ),
                          onTap: () {
                            // 주식 상세 페이지로 이동
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addStockToPortfolio('AAPL', 10);
                  },
                  child: const Text('Add AAPL 10 Shares'),
                ),
              ],
            ),
    );
  }
}
