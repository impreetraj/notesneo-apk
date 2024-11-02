import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/appPage/PdfOpen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  email() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourite",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favorite")
            .doc(email())
            .collection(email())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> FavData = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                           String image = FavData['image'].toString();
                                String name = FavData['name'].toString();
                                String discrptiion =
                                    FavData['discrptiion'].toString();
                                String pdf = FavData['pdf'].toString();
                                String main = FavData['main'].toString();
                      return Card(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                

                                return showModel(
                                  context,
                                  image , name , discrptiion , pdf , main
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 100,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                          child: Image.network(
                                        image,
                                        height: 70,
                                      )),
                                    )),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text(
                                        name,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              child: Text(
                                            discrptiion,
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                          child: CupertinoButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Favorite")
                                                    .doc(email())
                                                    .collection(email())
                                                    .doc(FavData['main'] +
                                                        FavData['name'])
                                                    .delete();
                                              },
                                              child: Icon(Icons.delete))),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(child: Text("No Data"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

showModel(BuildContext context,
    String image, String name, String discrption, String pdf, String main) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Image.network(
                image,
                height: 270,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 170,
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfOpen(pdf: pdf),));
                  },
                  child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.pink.shade400),
                      child: Center(
                          child: Text(
                        "VIEW PDF",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ))),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              Container(
                  child: Text(discrption,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)))
            ],
          ),
        )
      ],
    ),
  );
}
