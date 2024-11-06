
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/appPage/PdfOpen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemesterFive extends StatefulWidget {
  const SemesterFive({super.key});

  @override
  State<SemesterFive> createState() => _SemesterFiveState();
}

class _SemesterFiveState extends State<SemesterFive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semester 5"),
        centerTitle: true,

        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("adminsem").doc("semester").collection("semester5").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  return  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> BookData =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return Column(
                          children: [
                            Container(
                                child: Text(
                              BookData['main_name'].toString().toUpperCase(),
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            )),
                            Container(
                                child: Text(
                              BookData['main_decription'],
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w500),
                            )),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CupertinoButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return showModel(
                                               context,
                                                  BookData['image1'],
                                                  BookData['unit1_name'],
                                                  BookData['unit1_description'],
                                                  BookData['link1'],
                                                  BookData['main_name']);
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                           height: 270, 
                                           color: const Color.fromARGB(255, 250, 193, 193),    
                                          child: Image.network(
                                            BookData['image1'],
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return showModel(
                                              context,
                                                BookData['image2'],
                                                BookData['unit2_name'],
                                                BookData['unit2_description'],
                                                BookData['link2'],
                                                BookData['main_name']);
                                          },
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                           height: 270, 
                                           color: const Color.fromARGB(255, 250, 193, 193),    
                                          child: Image.network(
                                            BookData['image2'],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return showModel(
                                              context,
                                                BookData['image3'],
                                                BookData['unit3_name'],
                                                BookData['unit3_description'],
                                                BookData['link3'],
                                                BookData['main_name']);
                                          },
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                           height: 270, 
                                           color: const Color.fromARGB(255, 250, 193, 193),    
                                          child: Image.network(
                                            BookData['image3'],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return showModel(
                                              context , 
                                                BookData['image4'],
                                                BookData['unit4_name'],
                                                BookData['unit4_description'],
                                                BookData['link4'],
                                                BookData['main_name']);
                                          },
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                           height: 270, 
                                           color: const Color.fromARGB(255, 250, 193, 193),    
                                          child: Image.network(
                                            BookData['image4'],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    
                  );
                } else {
                  return Text("No data");
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ],
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
                Container(
                    margin: EdgeInsets.only(left: 30, bottom: 10),
                    child: CupertinoButton(
                        onPressed: () {
                          String email = " ";
                          var currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            email = currentUser.email.toString();
                          }

                          FirebaseFirestore.instance
                              .collection("Favorite")
                              .doc(email)
                              .collection(email)
                              .doc(main+name)
                              .set({
                            "name": name,
                            "discrptiion": discrption,
                            "pdf": pdf,
                            "main": main,
                            "image": image
                          });
                        },
                        child: Icon(Icons.favorite, size: 50))),
                SizedBox(
                  height: 170,
                ),
                CupertinoButton(
                   onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                  PdfOpen(pdf: pdf)
                                
                              ));
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
