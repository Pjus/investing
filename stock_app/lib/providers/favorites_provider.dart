import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'dart:convert';
import 'package:stock_app/utils/constants.dart';

class FavoritesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _allStocks = []; // 전체 주식 데이터
  List<Map<String, dynamic>> _originalStocks = []; // 필터링된 데이터

  List<Map<String, dynamic>> get allStocks => _allStocks; // Getter 추가

  Future<void> fetchFavorites(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      print("User is not authenticated.");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // API 호출 로직 (예시)
      final response = await http.get(
        Uri.parse(APIConstants.favoriteEndpoint),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        _favorites =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        print("Failed to fetch favorites: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(
      BuildContext context, String ticker, String name) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      print("User is not authenticated.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(APIConstants.favoriteEndpoint),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'ticker': ticker, 'name': name}),
      );

      if (response.statusCode == 201) {
        _favorites.add({'ticker': ticker, 'name': name});
        notifyListeners();
      } else {
        print("Failed to add favorite: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(BuildContext context, String ticker) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      print("User is not authenticated.");
      return;
    }

    // 로컬 상태를 먼저 업데이트
    final indexToRemove =
        _favorites.indexWhere((favorite) => favorite['ticker'] == ticker);
    if (indexToRemove != -1) {
      final removedFavorite = _favorites.removeAt(indexToRemove); // 로컬에서 제거
      notifyListeners(); // UI 즉시 업데이트

      try {
        // 서버와 동기화
        final response = await http.delete(
          Uri.parse('${APIConstants.favoriteDeleteEndpoint}$ticker/'),
          headers: {
            'Authorization': 'Bearer ${authProvider.token}',
          },
        );

        if (response.statusCode != 204) {
          // 서버에서 제거 실패 시 로컬 상태 복원
          _favorites.insert(indexToRemove, removedFavorite);
          notifyListeners();
          print("Failed to remove favorite: ${response.statusCode}");
        }
      } catch (e) {
        // 에러 발생 시 로컬 상태 복원
        _favorites.insert(indexToRemove, removedFavorite);
        notifyListeners();
        print("Error removing favorite: $e");
      }
    }
  }

  Future<void> fetchAllStocks(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/favorite/stocks/'),
        headers: {'Authorization': 'Bearer ${authProvider.token}'},
      );

      if (response.statusCode == 200) {
        _allStocks =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        _originalStocks = List<Map<String, dynamic>>.from(_allStocks);
      } else {
        print("Failed to fetch stocks: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching stocks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterFavorites(String query) {
    if (query.isEmpty) {
      _allStocks = List<Map<String, dynamic>>.from(
          _originalStocks); // 검색어가 없으면 원본 목록으로 복원
    } else {
      query = query.toLowerCase();
      _allStocks = _originalStocks
          .where((stock) =>
              stock['name'].toLowerCase().contains(query) ||
              stock['ticker'].toLowerCase().contains(query))
          .toList();
    }
    notifyListeners();
  }
}
