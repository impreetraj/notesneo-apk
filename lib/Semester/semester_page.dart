import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/widget/pdfopenBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemesterPage extends StatelessWidget {
  final String collectionName;
  final String title;
  const SemesterPage({super.key, required this.collectionName, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("adminsem")
                  .doc("semester")
                  .collection(collectionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> bookData =
                            snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Text(
                              bookData['main_name'].toString().toUpperCase(),
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              bookData['main_decription'],
                              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _imageButton(context, bookData, 1),
                                  _imageButton(context, bookData, 2),
                                  _imageButton(context, bookData, 3),
                                  _imageButton(context, bookData, 4),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No data"));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _imageButton(BuildContext context, Map<String, dynamic> bookData, int idx) {
    final imageKey = 'image$idx';
    final unitNameKey = 'unit${idx}_name';
    final unitDescKey = 'unit${idx}_description';
    final linkKey = 'link$idx';

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CupertinoButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return _showModel(
                context,
                bookData[imageKey],
                bookData[unitNameKey],
                bookData[unitDescKey],
                bookData[linkKey],
                bookData['main_name'],
              );
            },
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2.6,
          height: 270,
          color: const Color.fromARGB(255, 250, 193, 193),
          child: Image.network(
            bookData[imageKey] ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _showModel(BuildContext context, String image, String name, String discrption, String pdf, String main) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Image.network(
                  image,
                  height: 270,
                  width: MediaQuery.of(context).size.width / 2.2,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, bottom: 10),
                    child: CupertinoButton(
                      onPressed: () async {
                        String email = " ";
                        var currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null) {
                          email = currentUser.email.toString();
                        }

                        await FirebaseFirestore.instance
                            .collection("Favorite")
                            .doc(email)
                            .collection(email)
                            .doc(main + name)
                            .set({
                          "name": name,
                          "discrptiion": discrption,
                          "pdf": pdf,
                          "main": main,
                          "image": image
                        });
                      },
                      child: Icon(Icons.favorite, size: 50),
                    ),
                  ),
                  SizedBox(height: 170),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PdfOpen(pdf: pdf)),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.pink.shade400,
                      ),
                      child: Center(
                        child: Text(
                          "VIEW PDF",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Text(discrption, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
