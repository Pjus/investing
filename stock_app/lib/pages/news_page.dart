import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/news_provider.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    // 뉴스 데이터 로드
    if (newsProvider.newsData.isEmpty && !newsProvider.isLoading) {
      newsProvider.fetchNewsData();
    }

    return newsProvider.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: newsProvider.fetchNewsData, // 데이터 새로고침
            child: newsProvider.newsData.isEmpty
                ? const Center(
                    child: Text(
                      'No news available',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: newsProvider.newsData.length,
                    itemBuilder: (context, index) {
                      final newsItem = newsProvider.newsData[index];
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text(
                            newsItem['Title'], // 뉴스 제목
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            '${newsItem['Source']} - ${newsItem['Date']}', // 뉴스 출처 및 시간
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                          onTap: () {
                            showNewsDialog(
                                context, newsItem['Title'], newsItem['Link']);
                          },
                        ),
                      );
                    },
                  ),
          );
  }

  // 뉴스 상세 링크를 보여주는 다이얼로그
  void showNewsDialog(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Open this link?\n$url'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                launchUrl(Uri.parse(url)); // URL 열기
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }
}
