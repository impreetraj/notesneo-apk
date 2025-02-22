
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/Db_Helper/Dbhelper.dart';
import 'package:deepaknote/appPage/PdfOpen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  DBHelper? dbRef;

    @override
  void initState() {
    super.initState();
    dbRef = DBHelper.instance;
    
  }

  // Method to fetch all notes
 

  // Method to handle adding a new note
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("admin").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> BookData = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          SizedBox(
                            height: 17,
                          ),
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
                          SizedBox(
                            height: 10,
                          ),
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
                                                BookData['main_name'],
                                                dbRef!
                                                );
                                          },
                                        );
                                      },
                                      child: Container(
                                        color: const Color.fromARGB(
                                            255, 250, 193, 193),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        height: 270,
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
                                                BookData['main_name'],dbRef!);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        height: 270,
                                        color: const Color.fromARGB(
                                            255, 250, 193, 193),
                                        child: Image.network(
                                          BookData['image2'],
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
                                                BookData['image3'],
                                                BookData['unit3_name'],
                                                BookData['unit3_description'],
                                                BookData['link3'],
                                                BookData['main_name'],dbRef!);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        height: 270,
                                        color: const Color.fromARGB(
                                            255, 250, 193, 193),
                                        child: Image.network(
                                          BookData['image3'],
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
                                                BookData['image4'],
                                                BookData['unit4_name'],
                                                BookData['unit4_description'],
                                                BookData['link4'],
                                                BookData['main_name'],dbRef!);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        height: 270,
                                        color: const Color.fromARGB(
                                            255, 250, 193, 193),
                                        child: Image.network(
                                          BookData['image4'],
                                          fit: BoxFit.cover,
                                        ),
                                      )),
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

Future<String?> downloadFile(
    String name,
    String description, 
    String iUrl, 
    String imageName,
    String fUrl, 
    String fileName) async {
  try {
    Directory directory = await getApplicationDocumentsDirectory();
    
    // Full path for image
    String imagePath = '${directory.path}/$imageName';
    Dio dio = Dio();
    await dio.download(iUrl, imagePath);

    // Full path for file
    String filePath = '${directory.path}/$fileName';
    await dio.download(fUrl, filePath);

    // Store full file paths in database
    await DBHelper.instance.insertFile(name, description, filePath, imagePath);

    return filePath;
  } catch (e) {
    print("Error downloading file: $e");
    return null;
  }
}


showModel(BuildContext context, String image, String name, String discrption,
    String pdf, String main , DBHelper dbRef) {
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
                width: MediaQuery.of(context).size.width / 2.2,
              ),
            ),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 30, bottom: 10),
                    child: CupertinoButton(
                        onPressed: () async {
                          String filePath = name + ".pdf";
                          String imagePath = name + ".jpeg";
                        //  String? doFile = await downloadFile(image, filePath, "pdf");
                        //  String? doimage = await downloadFile(image, imagePath, "jpeg");
                           downloadFile(name, discrption, image, imagePath,pdf,filePath);

                          // String email = " ";
                          // var currentUser = FirebaseAuth.instance.currentUser;
                          // if (currentUser != null) {
                          //   email = currentUser.email.toString();
                          // }

                          // File? _imageFile;
                          // File? _pdfFile;

                          // String? _imageBase64;
                          // String? _pdfBase64;
                          // _imageFile = File(image);
                          // List<int> imageBytes = await _imageFile.readAsBytes();
                          // String base64Image = base64Encode(imageBytes);
                          // _imageBase64 = base64Image;

                          // _pdfFile = File(pdf);
                          // List<int> pdfBytes = await _pdfFile.readAsBytes();
                          // String base64pdf = base64Encode(pdfBytes);
                          // _pdfBase64 = base64pdf;

                          // Map<String, dynamic> user = {
                          //   'title': name,
                          //   'descrption': discrption,
                          //   'image': _imageBase64,
                          //   'pdf': _pdfBase64
                          // };

                          // await DBHelper.dbHelper.insertBook(user);

                          // FirebaseFirestore.instance
                          //     .collection("Favorite")
                          //     .doc(email)
                          //     .collection(email)
                          //     .doc(main + name)
                          //     .set({
                          //   "name": name,
                          //   "discrptiion": discrption,
                          //   "pdf": pdf,
                          //   "main": main,
                          //   "image": image
                          // });
                        },
                        child: Icon(Icons.download, size: 50))),
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
