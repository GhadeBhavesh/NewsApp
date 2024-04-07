import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/pages/ViewNews.dart';

class NewsDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String newsUrl;

  const NewsDetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.newsUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to WebViewPage to show full article
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewNews(newsUrl: newsUrl),
                  ),
                );
              },
              child: Text('Read More'),
            ),
          ],
        ),
      ),
    );
  }
}
