import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/appPage/book.dart';
import 'package:deepaknote/appPage/bottomNav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("NotesNeo"), Icon(Icons.logout)],
              ),
            ),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.admin_panel_settings_rounded),
              ),
              Tab(
                icon: Icon(Icons.home),
              )
            ]),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Upload(),
              ),
              Container(
                child: Book(),
              ),
            ],
          ),
        ));
  }
}

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController unit_1controller = TextEditingController();
  TextEditingController unit_2controller = TextEditingController();
  TextEditingController unit_3controller = TextEditingController();
  TextEditingController unit_4controller = TextEditingController();

  TextEditingController description_1controller = TextEditingController();
  TextEditingController description_2controller = TextEditingController();
  TextEditingController description_3controller = TextEditingController();
  TextEditingController description_4controller = TextEditingController();

  TextEditingController mainName_controller = TextEditingController();
  TextEditingController mainDescription_controller = TextEditingController();
  TextEditingController semester_controller = TextEditingController();

  Future<String?> uploadpdf(String fileName, File file) async {
    String main = mainName_controller.text.trim();
    final refernce =
        FirebaseStorage.instanceFor(bucket: 'gs://notesneo-63191.appspot.com')
            .ref()
            .child("pdfs/$main/$fileName.pdf");
    final uploadTask = refernce.putFile(file);

    await uploadTask.whenComplete(() {});

    final downloadLink = refernce.getDownloadURL();
    return downloadLink;
  }

  // void pickfile() async {
  //   final pickFile = await FilePicker.platform
  //       .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

  //   if (pickFile != null) {
  //     String fileName = pickFile.files[0].name;

  //     File file = File(pickFile.files[0].path!);

  //     final downloadlink = await uploadpdf(fileName, file);
  //   }
  // }

  bool submit = false;

  String? link1;
  String? file1;
  String? imgname1;
  File? image1;
  String? link2;
  String? file2;
  String? imgname2;
  File? image2;
  String? link3;
  String? file3;
  String? imgname3;
  File? image3;
  String? link4;
  String? file4;
  String? imgname4;
  File? image4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: [
                Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav(),));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30) , color: Colors.pink),
                  child: Center(child: Text("User", style: TextStyle(fontSize: 24 , fontWeight: FontWeight.w600 , color: Colors.black),)))),
            ),
                TextFormField(
                  controller: mainName_controller,
                  decoration: InputDecoration(
                      hintText: "Enter a note name",
                      hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: mainDescription_controller,
                  decoration: const InputDecoration(
                      hintText: "Enter a description",
                      hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: semester_controller,
                  decoration: const InputDecoration(
                      hintText: "Enter a semester (like 1,2,3,4,5,6,7,8 )",
                      hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Unit 1",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              XFile? selectedImage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage != null) {
                                File convertedfile = File(selectedImage.path);
                                String imgName = selectedImage.name;
                                setState(() {
                                  image1 = convertedfile;
                                  imgname1 = imgName;
                                });
                              }
                            },
                            child: Icon(
                              Icons.image,
                              size: 90,
                            ),
                          ),
                          Container(child: Text(imgname1.toString()))
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                              onPressed: () async {
                                final pickFile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf']);

                                if (pickFile != null) {
                                  String fileName = pickFile.files[0].name;

                                  File file = File(pickFile.files[0].path!);

                                  final downloadlink =
                                      await uploadpdf(fileName, file);

                                  setState(() {
                                    link1 = downloadlink;
                                    file1 = fileName;
                                  });
                                }
                              },
                              child: Icon(Icons.picture_as_pdf, size: 90)),
                          Container(
                              child: Text(file1.toString().toUpperCase())),
                        ],
                      ),
                      TextFormField(
                        controller: unit_1controller,
                        decoration: InputDecoration(
                            hintText: "Enter a Unit 1 Name",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: description_1controller,
                        decoration: InputDecoration(
                            hintText: "Enter a unit 1 description",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Unit 2",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              XFile? selectedImage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage != null) {
                                File convertedfile = File(selectedImage.path);
                                String imgName = selectedImage.name;
                                setState(() {
                                  image2 = convertedfile;
                                  imgname2 = imgName;
                                });
                              }
                            },
                            child: Icon(
                              Icons.image,
                              size: 90,
                            ),
                          ),
                          Text(imgname2.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                              onPressed: () async {
                                final pickFile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf']);

                                if (pickFile != null) {
                                  String fileName = pickFile.files[0].name;

                                  File file = File(pickFile.files[0].path!);

                                  final downloadlink =
                                      await uploadpdf(fileName, file);

                                  setState(() {
                                    link2 = downloadlink;
                                    file2 = fileName;
                                  });
                                }
                              },
                              child: Icon(Icons.picture_as_pdf, size: 90)),
                          Text(file2.toString()),
                        ],
                      ),
                      TextFormField(
                        controller: unit_2controller,
                        decoration: InputDecoration(
                            hintText: "Enter a Unit 2 Name",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: description_2controller,
                        decoration: InputDecoration(
                            hintText: "Enter a unit 2 description",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Unit 3",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              XFile? selectedImage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage != null) {
                                File convertedfile = File(selectedImage.path);
                                String imgName = selectedImage.name;
                                setState(() {
                                  image3 = convertedfile;
                                  imgname3 = imgName;
                                });
                              }
                            },
                            child: Icon(
                              Icons.image,
                              size: 90,
                            ),
                          ),
                          Text(imgname3.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                              onPressed: () async {
                                final pickFile = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf']);

                                if (pickFile != null) {
                                  String fileName = pickFile.files[0].name;

                                  File file = File(pickFile.files[0].path!);

                                  final downloadlink =
                                      await uploadpdf(fileName, file);

                                  setState(() {
                                    link3 = downloadlink;
                                    file3 = fileName;
                                  });
                                }
                              },
                              child: Icon(Icons.picture_as_pdf, size: 90)),
                          Text(file3.toString())
                        ],
                      ),
                      TextFormField(
                        controller: unit_3controller,
                        decoration: InputDecoration(
                            hintText: "Enter a Unit 3 Name",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: description_3controller,
                        decoration: InputDecoration(
                            hintText: "Enter a unit 3 description",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Unit 4",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              XFile? selectedImage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage != null) {
                                File convertedfile = File(selectedImage.path);
                                String imgName = selectedImage.name;
                                setState(() {
                                  image4 = convertedfile;
                                  imgname4 = imgName;
                                });
                              }
                            },
                            child: Icon(
                              Icons.image,
                              size: 90,
                            ),
                          ),
                          Text(imgname4.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () async {
                              final pickFile = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf']);

                              if (pickFile != null) {
                                String fileName = pickFile.files[0].name;

                                File file = File(pickFile.files[0].path!);

                                final downloadlink =
                                    await uploadpdf(fileName, file);

                                setState(() {
                                  link4 = downloadlink;
                                  file4 = fileName;
                                });
                              }
                            },
                            child: Icon(
                              Icons.picture_as_pdf,
                              size: 90,
                            ),
                          ),
                          Text(file4.toString())
                        ],
                      ),
                      TextFormField(
                        controller: unit_4controller,
                        decoration: InputDecoration(
                            hintText: "Enter a Unit 4 Name",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      TextFormField(
                        controller: description_4controller,
                        decoration: InputDecoration(
                            hintText: "Enter a unit 4 description",
                            hintStyle: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                    onPressed: () async {
                      setState(() {
                            submit = true;
                          });
                      
                      String main_name = mainName_controller.text.trim();
                      String main_description =
                          mainDescription_controller.text.trim();
                      String unit1_name = unit_1controller.text.trim();
                      String unit2_name = unit_2controller.text.trim();
                      String unit3_name = unit_3controller.text.trim();
                      String unit4_name = unit_4controller.text.trim();
                      String unit1_description =
                          description_1controller.text.trim();
                      String unit2_description =
                          description_2controller.text.trim();
                      String unit3_description =
                          description_3controller.text.trim();
                      String unit4_description =
                          description_4controller.text.trim();

                      if (main_name.length > 3 &&
                          main_description.length > 3 &&
                          unit1_name.length > 3 &&
                          unit2_name.length > 3 &&
                          unit3_name.length > 3 &&
                          unit4_name.length > 3 &&
                          unit1_description.length > 3 &&
                          unit2_description.length > 3 &&
                          unit3_description.length > 3 &&
                          unit4_description.length > 3 &&
                          image1 != null &&
                          image2 != null &&
                          image3 != null &&
                          image4 != null) {
                        // First img
                        UploadTask uploadTask1 = FirebaseStorage.instanceFor(
                                bucket: 'gs://notesneo-63191.appspot.com')
                            .ref()
                            .child("image/$main_name/$imgname1")
                            .putFile(image1!);

                        TaskSnapshot taskSnapshot1 = await uploadTask1;
                        String downImage1 =
                            await taskSnapshot1.ref.getDownloadURL();

                        //second img
                        UploadTask uploadTask2 = FirebaseStorage.instanceFor(
                                bucket: 'gs://notesneo-63191.appspot.com')
                            .ref()
                            .child("image/$main_name/$imgname2")
                            .putFile(image2!);

                        TaskSnapshot taskSnapshot2 = await uploadTask2;
                        String downImage2 =
                            await taskSnapshot2.ref.getDownloadURL();

                        //third image
                        UploadTask uploadTask3 = FirebaseStorage.instanceFor(
                                bucket: 'gs://notesneo-63191.appspot.com')
                            .ref()
                            .child("image/$main_name/$imgname3")
                            .putFile(image3!);

                        TaskSnapshot taskSnapshot3 = await uploadTask3;
                        String downImage3 =
                            await taskSnapshot3.ref.getDownloadURL();

                        //fourth image
                        UploadTask uploadTask4 = FirebaseStorage.instanceFor(
                                bucket: 'gs://notesneo-63191.appspot.com')
                            .ref()
                            .child("image/$main_name/$imgname4")
                            .putFile(image4!);

                        TaskSnapshot taskSnapshot4 = await uploadTask4;
                        String downImage4 =
                            await taskSnapshot4.ref.getDownloadURL();

                        await FirebaseFirestore.instance
                            .collection("admin")
                            .doc()
                            .set({
                          "main_name": main_name,
                          "main_decription": main_description,
                          "link1": link1,
                          "image1": downImage1,
                          "image2": downImage2,
                          "image3": downImage3,
                          "image4": downImage4,
                          "unit1_name": unit1_name,
                          "unit1_description": unit1_description,
                          "link2": link2,
                          "unit2_name": unit2_name,
                          "unit2_description": unit2_description,
                          "link3": link3,
                          "unit3_name": unit3_name,
                          "unit3_description": unit3_description,
                          "link4": link4,
                          "unit4_name": unit4_name,
                          "unit4_description": unit4_description,
                        });

                        String sem = semester_controller.text.trim().toString();

                        if (sem == "1") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "2") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "3") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "4") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "5") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "6") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "7") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        } else if (sem == "8") {
                          await FirebaseFirestore.instance
                              .collection("adminsem")
                              .doc("semester")
                              .collection("semester" + sem)
                              .doc()
                              .set({
                            "main_name": main_name,
                            "main_decription": main_description,
                            "link1": link1,
                            "image1": downImage1,
                            "image2": downImage2,
                            "image3": downImage3,
                            "image4": downImage4,
                            "unit1_name": unit1_name,
                            "unit1_description": unit1_description,
                            "link2": link2,
                            "unit2_name": unit2_name,
                            "unit2_description": unit2_description,
                            "link3": link3,
                            "unit3_name": unit3_name,
                            "unit3_description": unit3_description,
                            "link4": link4,
                            "unit4_name": unit4_name,
                            "unit4_description": unit4_description,
                          });
                        }

                        mainName_controller.clear();
                        mainDescription_controller.clear();
                        semester_controller.clear();

                        unit_1controller.clear();
                        unit_2controller.clear();
                        unit_3controller.clear();
                        unit_4controller.clear();

                        description_1controller.clear();
                        description_2controller.clear();
                        description_3controller.clear();
                        description_4controller.clear();

                        setState(() {
                          file1 = " ";
                          file2 = " ";
                          file3 = " ";
                          file4 = " ";

                          imgname1 = ' ';
                          imgname2 = ' ';
                          imgname3 = ' ';
                          imgname4 = ' ';

                          setState(() {
                            submit = false;
                          });
                        });
                      }
                    },
                    child:Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(30)),
                      child: submit ? Center(child: CircularProgressIndicator()) : Center(child: Text("Submit" , style: TextStyle(fontSize: 24 , color: Colors.white , fontWeight: FontWeight.w600),)),
                    )
                        )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
