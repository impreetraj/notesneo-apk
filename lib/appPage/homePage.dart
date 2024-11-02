import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/Semester/sem1.dart';
import 'package:deepaknote/Semester/sem2.dart';
import 'package:deepaknote/Semester/sem3.dart';
import 'package:deepaknote/Semester/sem4.dart';
import 'package:deepaknote/Semester/sem5.dart';
import 'package:deepaknote/Semester/sem6.dart';
import 'package:deepaknote/Semester/sem7.dart';
import 'package:deepaknote/Semester/sem8.dart';
import 'package:deepaknote/appPage/Admin.dart';
import 'package:deepaknote/loginIssue/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  email() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email.toString();
    }
  }

  logout() async {
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("NotesNeo"),
        backgroundColor: Colors.pink,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
              child: InkWell(
                  onTap: () {
                    String email = " ";
                    var currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      email = currentUser.email.toString();
                    }
                    if (email == "deepakmodi8676@gmail.com") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPanel(),
                          ));
                    } else {
                      const snackBar = SnackBar(
                        content: Center(child: Text('You Are not Admin')),
                      );


                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink),
                      child: Center(
                          child: Text(
                        "Admin",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )))),
            ),
            Image.asset("assets/logo/image.png"),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "NotesNeo",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "NotesNeo is your go-to platform for accessing and downloading free academic notes. We understand the importance of high-quality educational resources, and our mission is to make learning more accessible to everyone.",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 7,
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Whether you're a student looking for study materials or an educator sharing knowledge, NotesNeo provides a diverse collection of notes across various subjects.",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 7,
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Join our community and be a part of a platform that goes beyond traditional learning, offering a space where knowledge meets innovation.",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 7,
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Explore our repository of notes and enhance your academic journey with NotesNeo.",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Preet Raj",
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "B.Tech , Cse",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Roll no : 223024",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Full Stack App Developer",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Preet Raj",
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "B.Tech , Cse",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Roll no : 223024",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Full Stack App Developer",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Preet Raj",
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "B.Tech , Cse",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Roll no : 223024",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Full Stack App Developer",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color(0xff033a80),
              child: Center(
                  child: Container(
                      margin: EdgeInsets.only(right: 30.0, left: 30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Copyright © NotesNeo | All Rights Reserved ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ))),
            )
          ],
        ),
      ),
      endDrawer: Drawer(
          child: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User")
                .doc(email())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new CircularProgressIndicator();
              }
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;

              String image = profile['photoUrl'].toString();

              return Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(color: Colors.pink),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: (image == "null")
                                          ? Icon(
                                              Icons.person,
                                              size: 50,
                                            )
                                          : Image.network(image)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14.0, top: 10),
                                child: Container(
                                  child: Text(
                                    profile['name'].toString().toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14.0, top: 5),
                                child: Container(
                                  child: Text(
                                    profile['email'].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterOne()));
                            },
                            child: Text(
                              "Semester 1",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w600),
                            )),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterTwo()));
                            },
                            child: Text("Semester 2",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SemesterThree()));
                          },
                          child: Text("Semester 3",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterFour()));
                            },
                            child: Text("Semester 4",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterFive()));
                            },
                            child: Text("Semester 5",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterSix()));
                            },
                            child: Text("Semester 6",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterSeven()));
                            },
                            child: Text("Semester 7",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SemesterEight()));
                            },
                            child: Text("Semester 8",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: GestureDetector(
                            onTap: () {
                              logout();
                            },
                            child: Text("Logout",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ]),
              );
            }),
      )),
    );
  }
}