class APIConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static String get newsEndpoint => '$baseUrl/news/';
  static String get marketIndexEndpoint => '$baseUrl/market/';
  static String get stockDataEndpoint => '$baseUrl/stock/';
  static String get favoriteEndpoint => '$baseUrl/favorite/list/';
  static String get favoriteAddEndpoint => '$baseUrl/favorite/add/';
}
