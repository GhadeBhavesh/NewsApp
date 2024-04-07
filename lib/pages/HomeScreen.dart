import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/model/ArticalModel.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/components/dropDownList.dart';
import 'package:news_app/components/font_size.dart';
import 'package:news_app/model/utils.dart';
import 'package:news_app/pages/NewsDetail.dart';
import 'package:news_app/pages/ViewNews.dart';
import 'package:news_app/pages/bookmark.dart';
import "package:news_app/services/NewsController.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:news_app/components/home_ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsController newsController = Get.put(NewsController());
  final _databaseRef = FirebaseDatabase.instance.reference().child('bookmarks');
  bool _showFilterChips = false;

  @override
  void initState() {
    super.initState();
    FavotiteProvider.of(context, listen: false).loadBookmarks();
    getStoredCategory().then((category) {
      if (category != null) {
        setState(() {
          dropdownValue = category;
        });
        dropdownValue = category;
        newsController.category.value = category;
        newsController.getNews();
        updateNewsCategory(getStoredCategory() as String);
      }
    });
  }

  Future<String> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  bool _isCountryExpanded = false;
  bool _isCategoryExpanded = false;
  bool _isChannelExpanded = false;
  String dropdownValue = 'in';

  Future<String?> getStoredCategory() async {
    final snapshot = await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .get();
    return snapshot.value as String?;
  }

  Future<String?> getStoredChannel() async {
    final snapshot = await FirebaseDatabase.instance
        .reference()
        .child('selectedChannel')
        .get();
    return snapshot.value as String?;
  }

  void updateNewsCategory(String selectedValue) {
    newsController.category.value = selectedValue;
    newsController.getNews();
  }

  void updateNewsChannel(String selectedValue) {
    newsController.country.value = selectedValue;
    newsController.getNews();
  }

  void saveSelectedCategory(String categoryCode) async {
    await FirebaseDatabase.instance
        .reference()
        .child('selectedCategory')
        .set(categoryCode);
  }

  void saveSelectedChannel(String channelCode) async {
    await FirebaseDatabase.instance
        .reference()
        .child('selectedChannel')
        .set(channelCode);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final provider = FavotiteProvider.of(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "Headlines",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showFilterChips = !_showFilterChips; // Toggle visibility
                });
              },
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ],
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 100, right: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search any Thing",
                                  ),
                                  scrollPadding: EdgeInsets.all(5),
                                  onChanged: (val) {
                                    newsController.findNews.value = val;
                                    newsController.getNews(
                                        searchKey:
                                            val); // Update news on text change
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
              width: double.infinity,
              height: 700,
              child: Container(
                margin: EdgeInsets.only(left: 10.0),
                height: 100,
                child: Column(
                  children: [
                    if (_showFilterChips)
                      Wrap(
                        spacing: 8.0,
                        children: List<Widget>.generate(listOfCountry.length,
                            (int index) {
                          return FilterChip(
                            label: Text(
                                listOfCountry[index]['name']!.toUpperCase()),
                            selected:
                                dropdownValue == listOfCountry[index]['code'],
                            onSelected: (bool selected) {
                              setState(() {
                                dropdownValue = (selected
                                    ? listOfCountry[index]['code']
                                    : null)!;
                                newsController.country.value = dropdownValue;
                                newsController.getNews();
                                saveSelectedChannel(dropdownValue ??
                                    ''); // Save selected category
                                updateNewsChannel(dropdownValue ??
                                    ''); // Update news category
                              });
                            },
                          );
                        }),
                      ),
                    Expanded(
                      child: GetBuilder<NewsController>(
                        builder: (controller) {
                          return controller.notFound.value
                              ? Center(
                                  child: Text(
                                    "Not Found",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              : controller.news.length == 0
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      controller: controller.scrollController,
                                      itemCount: controller.news.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  NewsDetailPage(
                                                    imageUrl: controller
                                                            .news[index]
                                                            .urlToImage ??
                                                        '',
                                                    title: controller
                                                        .news[index].title,
                                                    description: controller
                                                            .news[index]
                                                            .description ??
                                                        '',
                                                    newsUrl: controller
                                                        .news[index].url,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Image Container
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child:
                                                            CachedNetworkImage(
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  "assets/news.png"),
                                                          imageUrl: controller
                                                                  .news[index]
                                                                  .urlToImage ??
                                                              '',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    // Title and Source Container
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Title
                                                          Text(
                                                            controller
                                                                .news[index]
                                                                .title,
                                                            style: TextStyle(
                                                              fontSize: Provider
                                                                      .of<FontSizeProvider>(
                                                                          context)
                                                                  .fontSize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(height: 5),
                                                          // Source Name
                                                          Text(
                                                            "${controller.news[index].source.name}",
                                                            style: TextStyle(
                                                              fontSize: Provider.of<
                                                                              FontSizeProvider>(
                                                                          context)
                                                                      .fontSize -
                                                                  2,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () => provider
                                                                .toggleFavorite(
                                                                    controller
                                                                            .news[
                                                                        index]),
                                                            child: Icon(
                                                              provider.isExit(
                                                                      controller.news[
                                                                          index])
                                                                  ? Icons
                                                                      .favorite
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
                                          ),
                                        );
                                      },
                                    );
                        },
                        init: NewsController(),
                      ),
                    ),
                  ],
                ),
              ))
        ]))));
  }
}
