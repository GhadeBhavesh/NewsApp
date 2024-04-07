import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/main.dart';
import 'package:news_app/pages/onboarding_page.dart';
import 'package:news_app/pages/welcome.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? imageUrl;
  String? name;
  String? email;
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const OnboardingPage())
        : Get.to(() => Draw());
  }

  Future<void> createUserWithEmailAndPassword(
      String userEmail, String userPass, String userName) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPass,
      );
      firebaseUser.value != null
          ? Get.offAll(() => Draw())
          : Get.to(() => const OnboardingPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("About user", "User message",
          backgroundColor: Colors.pink,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  Future<void> signInWithEmailAndPassword(
    String userEmail,
    String userPass,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPass);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("About Login", "Login message",
          backgroundColor: Colors.pink,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Get.offAll(() => const OnboardingPage());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> _getSavedCategoryFromFirestore() async {
    String savedCategory = '';
    try {
      // Access Firestore instance
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Get the current user
      final User? _user = AuthenticationRepository.instance.firebaseUser.value;

      // Check if user is authenticated
      if (_user != null) {
        // Fetch the user's saved category from Firestore
        final DocumentSnapshot documentSnapshot = await _firestore
            .collection('categories')
            .doc(_user.uid)
            .collection('user_categories')
            .doc(
                'saved_category') // Assuming there's a document named 'saved_category' containing the saved category
            .get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // Retrieve the saved category from the document
          savedCategory = documentSnapshot['category'] ?? '';
        }
      }
    } catch (e) {
      print("Error fetching saved category from Firestore: $e");
    }
    return savedCategory;
  }
}
