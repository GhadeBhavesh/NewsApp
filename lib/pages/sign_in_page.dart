import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/auth/sign_up_controller.dart';
import 'package:news_app/main.dart';
import 'package:news_app/pages/login_page.dart';
import 'package:news_app/auth/authentication_repository.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _currentUser;
  bool _isObsure = true;
  bool pass = true;
  RegExp Reqemail = RegExp(r"(?=.*[a-z])");
  bool validateEmail(String email) {
    String _Email = email.trim();
    if (Reqemail.hasMatch(_Email)) {
      return true;
    } else {
      return false;
    }
  }

  RegExp Reqpass = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String passord) {
    String _pass = passord.trim();
    if (Reqpass.hasMatch(_pass)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
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
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Get Started",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 40),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              onChanged: (value1) {
                                _formKey.currentState!.validate();
                              },
                              validator: (value1) {
                                if (value1!.isEmpty) {
                                  return "Please Enter UserName";
                                } else {
                                  return null;
                                }
                              },
                              controller: controller.userName,
                              decoration: const InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.person_outline_outlined),
                                  labelText: "UserName",
                                  hintText: "Full Name",
                                  border: const OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (value2) {
                                _formKey.currentState!.validate();
                              },
                              validator: (value2) {
                                if (value2!.isEmpty) {
                                  return "Please Enter Email Address";
                                } else {
                                  bool resEmail = validateEmail(value2);
                                  if (resEmail) {
                                    return null;
                                  } else {
                                    return 'Email must contain special character';
                                  }
                                }
                              },
                              controller: controller.userEmail,
                              decoration: const InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  labelText: "Email",
                                  hintText: "Email",
                                  border: const OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (value4) {
                                _formKey.currentState!.validate();
                              },
                              validator: (value4) {
                                if (value4!.isEmpty) {
                                  return "Please Enter Password";
                                } else {
                                  bool respass = validatePassword(value4);
                                  if (respass) {
                                    return null;
                                  } else {
                                    return 'Password must contain special,\nNumber & Capital character';
                                  }
                                }
                              },
                              obscureText: pass ? !_isObsure : false,
                              controller: controller.userPass,
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
                            Container(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      SignUpController.instance.registerUser(
                                        controller.userEmail.text.trim(),
                                        controller.userPass.text.trim(),
                                        controller.userName.text.trim(),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Sign up",
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
                                  onPressed: () {
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
                                          builder: (context) => login_page()));
                                },
                                child: const Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Already have a account ? ",
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: " login",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 51, 255))),
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
