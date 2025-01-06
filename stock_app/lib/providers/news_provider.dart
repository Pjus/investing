import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class NewsProvider extends ChangeNotifier {
  List<dynamic> _newsData = [];
  bool _isLoading = false;
  DateTime? _lastFetchTime; // 마지막으로 데이터를 가져온 시간
  final Duration _cacheDuration = Duration(minutes: 10); // 캐싱 시간 (10분)

  List<dynamic> get newsData => _newsData;
  bool get isLoading => _isLoading;

  Future<void> fetchNewsData() async {

      // 캐싱 유효성 검사
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      // 캐싱이 유효하면 API 요청 생략
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(APIConstants.newsEndpoint));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        _newsData = jsonResponse['data'] ?? [];
        _lastFetchTime = DateTime.now(); // 마지막 데이터 가져온 시간 업데이트
      } else {
        throw Exception('Failed to fetch news data');
      }
    } catch (error) {
      print('Error fetching news: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
}



