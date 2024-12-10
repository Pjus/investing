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
  List<Map<String, dynamic>> portfolioStocks = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPortfolioStocks();
  }

  Future<void> fetchPortfolioStocks() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

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
        hasError = true;
      });
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
        fetchPortfolioStocks();
      } else {
        throw Exception('Failed to add stock to portfolio');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stock: $e')),
      );
    }
  }

  Widget buildEmptyPortfolioView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Your portfolio is empty.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add stocks to your portfolio to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Example: Adding a stock directly for demonstration
              await addStockToPortfolio('AAPL', 10);
            },
            child: const Text('Add AAPL 10 Shares'),
          ),
        ],
      ),
    );
  }

  Widget buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load portfolio.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection or try again.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: fetchPortfolioStocks,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildPortfolioList() {
    return ListView.builder(
      itemCount: portfolioStocks.length,
      itemBuilder: (context, index) {
        final stock = portfolioStocks[index];
        return Card(
          child: ListTile(
            title: Text(stock['ticker']),
            subtitle: Text('Shares: ${stock['shares']}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () => removeStockFromPortfolio(stock['ticker']),
            ),
          ),
        );
      },
    );
  }

  Future<void> removeStockFromPortfolio(String ticker) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await http.delete(
        Uri.parse("http://127.0.0.1:8000/api/portfolio/$ticker/"),
        headers: {"Authorization": "Bearer ${authProvider.token}"},
      );

      if (response.statusCode == 204) {
        fetchPortfolioStocks();
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
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? buildErrorView()
              : portfolioStocks.isEmpty
                  ? buildEmptyPortfolioView()
                  : buildPortfolioList(),
    );
  }
}
