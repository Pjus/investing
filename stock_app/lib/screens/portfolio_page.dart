import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  final bool isLoggedIn;

  PortfolioPage({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: isLoggedIn
          ? Center(
              child: Text('Portfolio Page', style: TextStyle(fontSize: 20)))
          : Center(
              child: Text(
                'Please log in to access Portfolio',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
