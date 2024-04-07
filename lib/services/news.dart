import 'dart:convert';

import 'package:http/http.dart' as http;

class News {
  final String title;
  final String videoUrl;

  News({required this.title, required this.videoUrl});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      videoUrl: json['video_url'],
    );
  }
}

Future<List<News>> geetNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?sources=cnn,abc-news,nbc-news,fox-news,cbs-news&apiKey=YourApi'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['articles'];
    return jsonResponse
        .where((data) => data['urlToImage'] != null)
        .map((data) => News.fromJson(data))
        .toList();
  } else {
    throw Exception('Failed to load news');
  }
}
