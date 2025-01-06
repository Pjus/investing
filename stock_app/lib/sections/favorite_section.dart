import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stock_app/utils/constants.dart';

class FavoritesSection extends StatefulWidget {
  const FavoritesSection({super.key});

  @override
  State<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final response = await http.get(Uri.parse(APIConstants.favoriteEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favorites = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        print("Failed to load favorites: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching favorites: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          "No favorites available.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...favorites.map((favorite) => Card(
              color: Colors.grey[850],
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.yellow),
                title: Text(
                  favorite['ticker'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Price: \$${favorite['price'].toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  // 특정 종목 상세 페이지로 이동 (선택적으로 구현)
                },
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
