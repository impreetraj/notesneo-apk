import 'dart:io';

import 'package:deepaknote/Db_Helper/Dbhelper.dart';
import 'package:deepaknote/appPage/PdfOpen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.instance;
    getNotes();
  }

  // Method to fetch all notes
  void getNotes() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching
    });

    try {
      allNotes = await dbRef!.getFiles();
    } catch (e) {
      print("Error fetching notes: $e");
    }

    setState(() {
      isLoading = false; // Reset loading state
    });
  }

  // Method to fetch all notes

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
        body: Expanded(
          child: ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      String name = allNotes[index]['name'];
                      String discrption = allNotes[index]['file_title'];
                      String image = allNotes[index]['imagePath'];
                      String pdf = allNotes[index]['filePath'];

                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return showModel(
                              context, image, name, discrption, pdf);
                        },
                      );
                    },
                    child: Container(
                      height: 130,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                    child: Container(
                                        height: 100,
                                        width: 66,
                                        child: Image.file(
                                          File(allNotes[index]['imagePath']),
                                          fit: BoxFit.cover,
                                        ))),
                              )),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      allNotes[index]['name'].toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        height: 70,
                                        child: Text(
                                          allNotes[index]['file_title']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                  child: Center(child: Icon(Icons.delete))),
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
              }),
        ));
  }
}

showModel(BuildContext context, String image, String name, String discrption,
    String pdf) {
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
                child: Image.file(
                  File(image),
                  fit: BoxFit.cover,
                  height: 270,
                  width: MediaQuery.of(context).size.width / 2.2,
                )),
            Column(
              children: [
                SizedBox(
                  height: 170,
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfOpen(pdf: pdf),
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
