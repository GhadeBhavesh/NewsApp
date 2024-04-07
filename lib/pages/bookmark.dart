// import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:news_app/components/font_size.dart';
import 'package:news_app/pages/NewsDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/components/home_ui.dart';
import 'package:news_app/model/ArticalModel.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/services/NewsController.dart';
// import 'package:news_app/services/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:news_app/pages/account_page.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavotiteProvider.of(context);
    final finallist = provider._favorites;
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Bookmarks', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: [
          // Existing UI Widgets
          ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: Color.fromARGB(255, 0, 51, 255),
                child: SizedBox(
                  height: height * .2,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -250,
                        right: -300,
                        child: Circleui(height, width),
                      ),
                    ],
                  ),
                ),
              )),
          SizedBox(
              width: double.infinity,
              height: 800,
              child: Expanded(
                child: ListView.builder(
                    itemCount: finallist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  NewsDetailPage(
                                    imageUrl: finallist[index].urlToImage ?? '',
                                    title: finallist[index].title,
                                    description:
                                        finallist[index].description ?? '',
                                    newsUrl: finallist[index].url,
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Container
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset("assets/news.png"),
                                          imageUrl:
                                              finallist[index].urlToImage ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    // Title and Source Container
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Title
                                          Text(
                                            finallist[index].title,
                                            style: TextStyle(
                                              fontSize:
                                                  Provider.of<FontSizeProvider>(
                                                          context)
                                                      .fontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          // Source Name
                                          Text(
                                            "${finallist[index].source.name}",
                                            style: TextStyle(
                                              fontSize:
                                                  Provider.of<FontSizeProvider>(
                                                              context)
                                                          .fontSize -
                                                      2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                provider.toggleFavorite(
                                                    finallist[index]),
                                            child: Icon(
                                              provider.isExit(finallist[index])
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }),
              ))
        ]))));
  }
}

class FavotiteProvider with ChangeNotifier {
  final List<Article> _favorites = [];
  List<Article> get favorites => _favorites;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveBookmark(Article news) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(jsonEncode(news.toJson()));
    prefs.setStringList('favorites', favorites);
  }

  Future<void> _removeBookmark(Article news) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.removeWhere((element) => jsonDecode(element)['url'] == news.url);
    prefs.setStringList('favorites', favorites);
  }

  Future<void> loadBookmarks() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    _favorites.clear();
    for (final String json in favorites) {
      final Article news = Article.fromJson(jsonDecode(json));
      _favorites.add(news);
    }
    notifyListeners();
  }

  void toggleFavorite(Article news) {
    if (_favorites.contains(news)) {
      _removeBookmark(news);
      _favorites.remove(news);
    } else {
      _saveBookmark(news);
      _favorites.add(news);
    }
    notifyListeners();
  }

  bool isExit(Article news) {
    return _favorites.contains(news);
  }

  static FavotiteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavotiteProvider>(context, listen: listen);
  }
}
                          // leading: CachedNetworkImage(
                          //   imageUrl: finallist[index].urlToImage ?? "",
                          //   placeholder: (context, url) =>
                          //       CircularProgressIndicator(),
                          //   errorWidget: (context, url, error) =>
                          //       Icon(Icons.error),
                          // ),

                          // title: Text(finallist[index].title),