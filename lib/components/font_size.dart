import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart'; // For @required annotation

class FontSizeProvider extends ChangeNotifier {
  final DatabaseReference _fontSizeRef =
      FirebaseDatabase.instance.reference().child('fontSize');
  double _fontSize = 16.0; // Initial default value

  double get fontSize => _fontSize;

  FontSizeProvider() {
    // Fetch initial font size from Firebase on provider creation
    _fontSizeRef.once().then((snapshot) {
      if (snapshot.snapshot.value is double) {
        _fontSize = snapshot.snapshot.value as double;
      }
      notifyListeners(); // Notify listeners after fetching and setting value
    });
  }

  void setFontSize(double newFontSize) {
    _fontSize = newFontSize;
    _fontSizeRef.set(newFontSize); // Update Firebase with new value
    notifyListeners();
  }
}
