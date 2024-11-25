import 'package:flutter/material.dart';

// Settings 페이지
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Settings'),
      ),
      body: Center(
        child: Text(
          "Settings Page",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
