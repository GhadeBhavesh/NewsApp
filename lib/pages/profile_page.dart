import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile_page extends StatelessWidget {
  const Profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Image(
                  height: 100,
                  width: 100,
                  image: user!.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : NetworkImage("assets/profile.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text("Edit your profile picture"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Profile Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text("Name:")),
                  Expanded(flex: 4, child: Text("bhavesh Ghade")),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right))
                ],
              ),
            )
          ]),
        ));
  }
}
