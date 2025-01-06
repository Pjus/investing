import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sections/portfolio_section.dart'; // PortfolioSection import
import '../sections/favorite_section.dart'; // FavoritesSection import
import '../sections/login_prompt.dart'; // LoginPrompt import
import 'market_index_page.dart';
import 'news_page.dart';
import '../providers/auth_provider.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Index",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MarketIndexPage(),
                    const SizedBox(height: 20),
                    const Text(
                      "Your Portfolio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (authProvider.isLoggedIn) ...[
                      const PortfolioSection(),
                      const SizedBox(height: 20),
                      const FavoritesSection(),
                    ] else
                      const LoginPrompt(),
                    const SizedBox(height: 20),
                    const Text(
                      "News",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NewsPage(),
        ),
      ),
    );
  }
}
