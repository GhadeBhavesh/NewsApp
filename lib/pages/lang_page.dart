import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/pages/account_page.dart';

class Lang_Page extends StatefulWidget {
  const Lang_Page({super.key});

  @override
  State<Lang_Page> createState() => _Lang_PageState();
}

class _Lang_PageState extends State<Lang_Page> {
  DatabaseReference _languageRef =
      FirebaseDatabase.instance.reference().child('language');
  String _selectedLanguage = 'English'; //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Get.to(Account());
                },
                icon: Icon(Icons.arrow_back)),
            title: const Text('Language'),
          ),
          body: Center(),
        ));
  }
}
