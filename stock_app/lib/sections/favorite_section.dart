import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/favoriate_page.dart';

import 'package:stock_app/utils/constants.dart';

import 'package:provider/provider.dart';
import 'package:stock_app/providers/auth_provider.dart'; // AuthProvider 가져오기
import 'package:stock_app/providers/favorites_provider.dart';

class FavoritesSection extends StatefulWidget {
  const FavoritesSection({super.key});

  @override
  State<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;
  bool isAdding = false; // Add More 상태 관리

  @override
  void initState() {
    super.initState();
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    favoritesProvider.fetchFavorites(context); // 전체 데이터를 초기화
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    if (favoritesProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (favoritesProvider.favorites.isEmpty) {
      return Column(
        children: [
          Center(
            child: Text(
              "No favorites added.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites'); // Favorite 페이지로 이동
              },
              child: const Text("Add More"),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favorites",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ...favoritesProvider.favorites.map((favorite) => Card(
              child: ListTile(
                title: Text("${favorite['ticker']}".toUpperCase()),
                subtitle: Text("Price: \$${favorite['price']}"),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    favoritesProvider.removeFavorite(
                        favorite['ticker'], favorite['name']);
                  },
                ),
              ),
            )),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorites'); // Favorite 페이지로 이동
            },
            child: const Text("Add More"),
          ),
        ),
      ],
    );
  }
}
