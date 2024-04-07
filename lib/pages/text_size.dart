import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:news_app/pages/HomeScreen.dart';
import 'package:news_app/pages/account_page.dart';

class TextSizePage extends StatefulWidget {
  @override
  _TextSizePageState createState() => _TextSizePageState();
}

class _TextSizePageState extends State<TextSizePage> {
  double _fontSize = 16.0;
  DatabaseReference? _fontSizeRef;

  @override
  void initState() {
    super.initState();
    _fontSizeRef = FirebaseDatabase.instance.reference().child('fontSize');
    _fontSizeRef?.onValue.listen((event) {
      setState(() {
        if (event.snapshot.value != null && event.snapshot.value is double) {
          _fontSize = event.snapshot.value as double;
        } else {
          // Handle null value or incompatible type (e.g., set to default or log error)
          print('Error: Unexpected data type for fontSize');
          _fontSize = 16.0; // Or any other default value
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Text Change with Slider"),
          centerTitle: true,
        ),
        body: Column(children: [
          Text(
            "Font size",
            style: TextStyle(
              fontSize: _fontSize,
            ),
          ),
          SizedBox(
            width: 270,
            child: Slider(
              value: _fontSize,
              activeColor: Colors.black,
              inactiveColor: Colors.grey,
              min: 10.0,
              max: 30.0,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
                _fontSizeRef?.set(value);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
