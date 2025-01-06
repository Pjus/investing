import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'dark_mode_provider.dart';

List<ChangeNotifierProvider> appProviders = [
  ChangeNotifierProvider(create: (_) => AuthProvider()..checkLoginStatus()),
];
