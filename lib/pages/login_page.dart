import 'package:flutter/material.dart';
import 'package:news_app/main.dart';
import 'package:news_app/pages/HomeScreen.dart';
import 'package:news_app/pages/sign_in_page.dart';
import 'package:get/get.dart';
import 'package:news_app/auth/sign_up_controller.dart';
import 'package:news_app/auth/authentication_repository.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  bool _isObsure = true;
  bool pass = true;
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  Color pinki = Colors.pink;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(children: [
            Image.asset("assets/bg1.png"),
            Padding(
              padding: EdgeInsets.only(top: 180),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80))),
                padding: const EdgeInsets.all(36),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Welcome Back",
                              style: TextStyle(fontSize: 40),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller: controller.userEmail,
                              decoration: const InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.person_outline_outlined),
                                  labelText: "Email",
                                  hintText: "Email",
                                  border: const OutlineInputBorder()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: controller.userPass,
                              obscureText: pass ? !_isObsure : false,
                              decoration: InputDecoration(
                                  suffixIcon: pass
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isObsure = !_isObsure;
                                            });
                                          },
                                          icon: Icon(
                                            _isObsure
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ))
                                      : null,
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  labelText: "Password",
                                  hintText: "Password",
                                  border: const OutlineInputBorder()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  },
                                  child: const Text("Forget Password ?")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    SignUpController.instance.login(
                                        controller.userEmail.text.trim(),
                                        controller.userPass.text.trim());
                                  },
                                  child: const Text(
                                    "login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 0, 51, 255),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40))),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: 60,
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: const Image(
                                    image: AssetImage("assets/google.png"),
                                  ),
                                  label: const Text("Sign in with Google",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  onPressed: () async {
                                    SignUpController.instance.loginWithGoogle();
                                    // Check if the user is authenticated after Google Sign-In
                                    if (AuthenticationRepository
                                            .instance.firebaseUser.value !=
                                        null) {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) {
                                          return Draw();
                                        },
                                      ));
                                    }
                                  },
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInPage()));
                                },
                                child: const Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Don't have a account ? ",
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: " Sign In",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 51, 255),
                                      )),
                                ])))
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
