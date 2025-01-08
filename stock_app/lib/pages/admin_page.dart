import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stock_app/providers/auth_provider.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> _fetchStocks() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print(authProvider.token);
    try {
      var response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/fetch-stocks/'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchStocks,
              child: Text('Fetch Stocks'),
            ),
          ],
        ),
      ),
    );
  }
}
