import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/favoriate_page.dart';

import 'package:stock_app/utils/constants.dart';

import 'package:provider/provider.dart';
import 'package:stock_app/providers/favorites_provider.dart';
import 'package:stock_app/providers/auth_provider.dart'; // AuthProvider 가져오기

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
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(APIConstants.favoriteEndpoint),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

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
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    if (favoritesProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (isAdding) {
      return Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => FavoritesPage(),
          );
        },
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
                subtitle: Text("Price: \$${favorite['current_price']}"),
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
