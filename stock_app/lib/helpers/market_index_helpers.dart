import 'package:flutter/material.dart';

Widget buildLoadingCard() {
  return Card(
    color: Colors.grey[850],
    child: ListTile(
      leading: const CircularProgressIndicator(color: Colors.white),
      title: const Text(
        'Loading...',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget buildErrorCard() {
  return Card(
    color: Colors.grey[850],
    child: ListTile(
      leading: const Icon(Icons.error, color: Colors.red),
      title: const Text(
        'Failed to load data.',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
