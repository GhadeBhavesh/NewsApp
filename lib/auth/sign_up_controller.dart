import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final userEmail = TextEditingController();
  final userPass = TextEditingController();
  final userName = TextEditingController();

  void registerUser(String userEmail, String userPass, String userName) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(userEmail, userPass, userName);
  }

  void login(String userEmail, String userPass) async {
    AuthenticationRepository.instance.signInWithEmailAndPassword(
      userEmail,
      userPass,
    );
  }

  void loginWithGoogle() async {
    await AuthenticationRepository.instance.signInWithGoogle();
  }
}
