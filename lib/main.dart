import 'package:deepaknote/appPage/Admin.dart';
import 'package:deepaknote/appPage/book.dart';
import 'package:deepaknote/appPage/bottomNav.dart';
import 'package:deepaknote/appPage/feedback.dart';
import 'package:deepaknote/appPage/homePage.dart';
import 'package:deepaknote/loginIssue/Splash.dart';
import 'package:deepaknote/loginIssue/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDBCjqWipbSORzpa4l2oKOqGzeViHj___g",
          appId: "1:55496018574:android:a6d4fa2f683ac9913517df",
          messagingSenderId: "55496018574",
          projectId: "notesneo-63191",
          
          ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  (FirebaseAuth.instance.currentUser != null) ? BottomNav() : Splash(),
      // home:  Feedbacks(),
    );
  }
}
