// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:news_app/pages/bookmark.dart';
// import 'package:news_app/services/news.dart';
// import 'package:provider/provider.dart';

// class FavoriteProvider extends ChangeNotifier {
//   List<String> _news = [];
//   List<String> get news => _news;

//   void toggleFavorite(String news) {
//     final isExist = _news.contains(news);
//     if (isExist) {
//       _news.remove(news);
//     } else {
//       _news.add(news);
//     }
//     notifyListeners();
//   }

//   bool isExist(String news) {
//     final isExist = _news.contains(news);
//     return isExist;
//   }

//   void clearFavorite() {
//     _news = [];
//     notifyListeners();
//   }

//   void loadFavorites() async {
//     final favoritesRef =
//         FirebaseDatabase.instance.reference().child('favorites');
//     final snapshot = await favoritesRef.get();
//     final favoritesList =
//         snapshot.children.map((child) => Favorite.fromSnapshot(child)).toList();
//     favorites = favoritesList;
//     notifyListeners();
//   }
  
// void addFavorite(Article news) {
//     final favorite =
//         Favorite(title: news.title, imageUrl: news.urlToImage ?? "");
//     favorites.add(favorite);
//     notifyListeners();
//   }
//   static FavoriteProvider of(
//     BuildContext context, {
//     bool listen = true,
//   }) {
//     return Provider.of<FavoriteProvider>(
//       context,
//       listen: listen,
//     );
//   }
// }
