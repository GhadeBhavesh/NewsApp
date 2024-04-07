import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/authentication_repository.dart';
import 'package:news_app/components/font_size.dart';
import 'package:news_app/pages/HomeScreen.dart';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/pages/bookmark.dart';
import 'package:news_app/pages/category_Page.dart';
import 'package:news_app/pages/onboarding_page.dart';
import 'package:news_app/pages/videopage.dart';
import 'package:news_app/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization(null);
  await Firebase.initializeApp()
      .then((value) => Get.put(AuthenticationRepository()));
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;
  // await Hive.initFlutter();

  runApp(ChangeNotifierProvider(
      create: (context) => FontSizeProvider(),
      child: MyApp(showHome: showHome)));
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FavotiteProvider(),
        child: GetMaterialApp(
          title: 'NewsApp',
          debugShowCheckedModeBanner: false,
          home: showHome ? OnboardingPage() : Draw(),
        ));
  }
}

class Draw extends StatefulWidget {
  Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Widget pages = HomeScreen();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(builder: (context) {
        return MenuScreen(
          onPageChanged: (a) {
            setState(() {
              pages = a;
            });
            ZoomDrawer.of(context)!.close();
          },
        );
      }),
      mainScreen: pages,
      borderRadius: 24,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.grey,
      menuBackgroundColor: Colors.indigo,
    );
  }
}

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key, required this.onPageChanged}) : super(key: key);

  final Function(Widget) onPageChanged;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ListItems> drawerItems = [
    ListItems(Icon(Icons.home), Text('Home'), HomeScreen()),
    ListItems(Icon(Icons.account_circle), Text('Video'), VideoPage()),
    ListItems(
        Icon(Icons.category),
        Text('Category'),
        CategoryNews(
          name: 'general',
        )),
    ListItems(Icon(Icons.bookmark), Text('Bookmark'), BookmarkScreen()),
    ListItems(Icon(Icons.account_circle), Text('Account'), Account()),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Theme(
            data: ThemeData.dark(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: drawerItems
                        .map((e) => ListTile(
                              onTap: () {
                                widget.onPageChanged(e.page);
                              },
                              title: e.title,
                              leading: e.icon,
                            ))
                        .toList()),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: OutlinedButton(
                      onPressed: () {
                        AuthenticationRepository.instance.signOut();
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )));
  }
}

class ListItems {
  final Icon icon;
  final Text title;
  final Widget page;
  ListItems(this.icon, this.title, this.page);
}
