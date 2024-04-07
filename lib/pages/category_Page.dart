import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:news_app/components/font_size.dart';
import 'package:news_app/components/home_ui.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/model/show_category.dart';

import 'package:news_app/pages/account_page.dart';
import 'package:news_app/components/article_view.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/show_category_news.dart';
import 'package:provider/provider.dart';

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  late String selectedCategory;
  List<ShowCategoryModel> categoriess = [];
  List<CategoryModel> categories = [];
  int activeIndex = 0;
  // bool _loading = true;

  @override
  void initState() {
    selectedCategory = widget.name.toLowerCase();
    categories = getCategories();
    super.initState();
    getNews();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(selectedCategory);
    categoriess = showCategoryNews.categories;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        title: Text(
          "Category",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        image: categories[index].image,
                        categoryName: categories[index].categoryName,
                        onTap: () {
                          setState(() {
                            selectedCategory =
                                categories[index].categoryName!.toLowerCase();
                            getNews();
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              // Existing UI Widgets
              SizedBox(
                width: double.infinity,
                height: 550,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: categoriess.length,
                  itemBuilder: (context, index) {
                    return ShowCategory(
                      Image: categoriess[index].urlToImage!,
                      desc: categoriess[index].description!,
                      title: categoriess[index].title!,
                      url: categoriess[index].url!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  final Function onTap;

  CategoryTile({
    this.categoryName,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  String Image, desc, title, url;
  ShowCategory(
      {required this.Image,
      required this.desc,
      required this.title,
      required this.url});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArticleView(blogUrl: url)));
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
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      imageUrl: Image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Title and Source Container
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize:
                              Provider.of<FontSizeProvider>(context).fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      // Source Name
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize:
                              Provider.of<FontSizeProvider>(context).fontSize -
                                  2,
                          color: Colors.grey,
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
  }
}
