import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/ArticalModel.dart';
import 'package:news_app/model/NewsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/services/news.dart';

class NewsController extends GetxController {
  final DatabaseReference _newsRef =
      FirebaseDatabase.instance.reference().child('news');

  Future<Object?> getSelectedCategory() async {
    try {
      DataSnapshot dataSnapshot =
          (await _newsRef.child('selectedCategory').once()) as DataSnapshot;
      return dataSnapshot.value;
    } catch (e) {
      print("Error getting selected category: $e");
      return null;
    }
  }

  Future<Object?> getSelectedChannel() async {
    try {
      DataSnapshot dataSnapshot =
          (await _newsRef.child('selectedChannel').once()) as DataSnapshot;
      return dataSnapshot.value;
    } catch (e) {
      print("Error getting selected channel: $e");
      return null;
    }
  }

  List<Article> news = <Article>[];
  ScrollController scrollController = ScrollController();
  RxBool notFound = false.obs;
  RxBool isLoading = false.obs;
  RxString channel = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString findNews = ''.obs;

  RxInt pageNum = 1.obs;
  dynamic isSwitched = false.obs;
  dynamic isPageLoading = false.obs;
  // RxInt pageSize = 10.obs;
  String baseApi = "https://newsapi.org/v2/top-headlines?";

  @override
  void onInit() {
    // scrollController = new ScrollController()..addListener(_scrollListener);
    getNews();
    super.onInit();
  }

  changeTheme(value) {
    // Get.changeTheme(value == true ? ThemeData.dark() : ThemeData.light());
    if (value = true) {
      Get.changeTheme(ThemeData.dark());
      isSwitched = value;
      update();
    } else {
      Get.changeTheme(ThemeData.light());
      isSwitched = value;
      update();
    }
  }

  getNews({searchKey = '', reload = false}) async {
    notFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
      channel.value = '';
    }
    baseApi = "https://newsapi.org/v2/top-headlines?";
    baseApi += country == '' ? 'country=in&' : 'country=$country&';
    baseApi += channel == '' ? 'channel=bbc-news&' : 'channel=$channel&';
    baseApi += category == '' ? '' : 'category=$category&';
    // baseApi += channel == '' ? '' : 'channel=$channel&';
    baseApi += 'apiKey=YourApi';
    // if (channel != '') {
    //   country.value = '';
    //   category.value = '';
    //   baseApi =
    //       "https://newsapi.org/v2/top-headlines?sources=$channel&apiKey=YourApi";
    // }
    if (searchKey != '') {
      country.value = '';
      category.value = '';
      baseApi =
          "https://newsapi.org/v2/top-headlines?q=$searchKey&apiKey=YourApi";
    }
    print(baseApi);
    getDataFromApi(baseApi);
  }

  getDataFromApi(url) async {
    // update();
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.newsFromJson(res.body);

      if (newsData.articles.length == 0 && newsData.totalResults == 0) {
        notFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          news = [...news, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.length != 0) {
            news = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        notFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      notFound.value = true;
      update();
    }
  }
}
