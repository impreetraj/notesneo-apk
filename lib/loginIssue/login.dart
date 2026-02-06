import 'package:deepaknote/widget/bottomNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Use the plugin singleton. Avoid constructing GoogleSignIn directly
  // because the current plugin version doesn't expose that constructor.
  Future<void> loginWithGoogle() async {
    try {
      // Ensure the plugin is initialized with the Android server client ID
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '55496018574-ku6m442lm5mpd7983520r3fg9qm9qb5l.apps.googleusercontent.com',
      );

      // Authenticate using the new API (authenticate() is supported on Android)
      final googleUser = await GoogleSignIn.instance.authenticate();

        final googleAuth = await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('Google Sign-In Error: idToken is null');
        return;
      }

      final cred = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(cred);
      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection("User").doc(user.email).set({
          "name": user.displayName,
          "email": user.email,
          "photoUrl": user.photoURL,
        }, SetOptions(merge: true));
      }

      // Navigate to BottomNav after successful login
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } catch (ex) {
      print("Google Sign-In Error: ${ex.toString()}");
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
                loginWithGoogle();
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
