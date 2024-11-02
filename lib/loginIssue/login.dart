import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/appPage/bottomNav.dart';
import 'package:deepaknote/appPage/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  loginwithGoogle() async {
    try {
      final googleuser = await GoogleSignIn().signIn();

      var name = googleuser?.displayName.toString();
      var email = googleuser?.email.toString();
      var photoUrl = googleuser?.photoUrl.toString();

      Map<String, dynamic> Userdata = {
        "name": name.toString(),
        "email": email.toString(),
        "photoUrl": photoUrl.toString(),
      };

      FirebaseFirestore.instance.collection("User").doc(email).set(Userdata);

      final googleAuth = await googleuser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await FirebaseAuth.instance
          .signInWithCredential(cred)
          .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              )));
    } catch (ex) {
      return print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Lottie.asset("assets/lottie/note.json",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.4),
            SizedBox(
              height: 40,
            ),
            CupertinoButton(
              onPressed: () {
                loginwithGoogle();
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    color: const Color.fromARGB(255, 154, 72, 99)),
                child: Center(
                    child: Text(
                  "Sign In With Google",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          ],
        ));
  }
}
