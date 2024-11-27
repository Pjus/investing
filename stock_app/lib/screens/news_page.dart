import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<dynamic> newsData = []; // 뉴스 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태
  int displayedItemCount = 5; // 기본적으로 표시할 뉴스 개수

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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 외부 스크롤과 충돌 방지
            itemCount: displayedItemCount,
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
          ),
        ),
        if (displayedItemCount < newsData.length) // "더 보기" 버튼 표시 조건
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  // 뉴스 리스트 확장
                  displayedItemCount += 5; // 5개씩 추가
                  if (displayedItemCount > newsData.length) {
                    displayedItemCount = newsData.length;
                  }
                });
              },
              child: const Text(
                'Load More',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
      ],
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
