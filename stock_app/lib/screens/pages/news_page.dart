import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> newsData = []; // 뉴스 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    fetchNewsData(); // 뉴스 데이터를 가져옴
  }

  Future<void> fetchNewsData() async {
    const url = 'http://127.0.0.1:8000/api/news/'; // Django 백엔드 API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          newsData = jsonResponse['data']; // 뉴스 데이터 저장
          isLoading = false; // 로딩 상태 종료
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch news data')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : newsData.isEmpty
            ? const Center(
                child: Text(
                  'No news available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: newsData.length,
                itemBuilder: (context, index) {
                  final newsItem = newsData[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(
                        newsItem['Title'], // 뉴스 제목
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${newsItem['Source']} - ${newsItem['Date']}', // 뉴스 출처 및 시간
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                      onTap: () {
                        // 뉴스 링크 열기
                        showNewsDialog(newsItem['Title'], newsItem['Link']);
                      },
                    ),
                  );
                },
              );
  }

  // 뉴스 상세 링크를 보여주는 다이얼로그
  void showNewsDialog(String title, String url) {
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
                // URL을 디바이스 브라우저에서 열기
                launchUrl(Uri.parse(url));
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }
}
