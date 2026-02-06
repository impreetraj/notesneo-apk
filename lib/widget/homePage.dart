import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/widget/Admin.dart';
import 'package:deepaknote/loginIssue/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:deepaknote/services/recent_service.dart';
import 'package:deepaknote/widget/pdfopenBook.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController reviewcontroller = TextEditingController();

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> recentNotes = [];

  @override
  void initState() {
    super.initState();
    _loadRecentNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadRecentNotes() async {
    final recent = await RecentService.getRecent();
    setState(() {
      recentNotes = recent;
    });
  }

  email() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email.toString();
    }
  }

  logout() async {
    await GoogleSignIn.instance.disconnect();
    await FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        )));
  }


  Widget _buildRecentImage(String image) {
    if (image.isEmpty) return Icon(Icons.description, color: Colors.teal[400]);
    
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.description, color: Colors.teal[400]),
      );
    } else {
      final file = File(image);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      }
      return Icon(Icons.description, color: Colors.teal[400]);
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildAboutFeature(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal[400]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.teal[400], size: 20),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOpinionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Share Your Opinion", style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.bold)),
        content: TextField(
          controller: reviewcontroller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "What do you think about the app?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.teal[400]!),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reviewcontroller.text.trim().isEmpty) return;

              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection("reviews").add({
                  "name": user.displayName ?? "Anonymous",
                  "email": user.email,
                  "profile": user.photoURL ?? "",
                  "review": reviewcontroller.text.trim(),
                  "timestamp": FieldValue.serverTimestamp(),
                });
                reviewcontroller.clear();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Thank you for your feedback!")),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("NotesNeo"),
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadRecentNotes,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Recent Activity (Moved Up)
                ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: RecentService.recentNotesNotifier,
                  builder: (context, notes, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Recent Activity"),
                        if (notes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              color: Colors.grey[50],
                              child: ListTile(
                                leading: Icon(Icons.history, color: Colors.grey),
                                title: Text("No recent activity", style: TextStyle(color: Colors.grey)),
                                subtitle: Text("Your last viewed notes will appear here"),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return Card(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildRecentImage(note['image']),
                                  ),
                                  title: Text(note['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text("Recently viewed"),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () async {
                                    await RecentService.addRecent(note);
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfOpen(
                                            pdf: note['pdf'],
                                            name: note['name'],
                                            image: note['image'],
                                            initialPage: (note['page'] is String) ? int.tryParse(note['page']) : (note['page'] is int ? note['page'] as int : null),
                                          ),
                                        ),
                                      ).then((_) => _loadRecentNotes());
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),

                // Share Opinion Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: _showOpinionDialog,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[50]!, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.teal[400]!.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal[400]!.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal[400]!.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.rate_review, color: Colors.teal[400]),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Share Your Opinion", 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal[700])),
                                Text("We value your feedback to improve!", 
                                  style: TextStyle(fontSize: 12, color: Colors.teal[400]!.withOpacity(0.7))),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal[400]),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Admin Button (Moved from top or integrated)
                Center(
                    child: InkWell(
                        onTap: () {
                          String email = " ";
                          var currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            email = currentUser.email.toString();
                          }
                          if (email == "deepakmodi8676@gmail.com" ||
                              email == "preetrajoffical@gmail.com" ||
                              email == "nubhawbarnwal@gmail.com" ||
                              email == "nitishmodi78@gmail.com" ||
                              email == "saitmpreet1234@gmail.com") {
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
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[200]),
                            child: Center(
                                child: Text(
                              "Admin Panel",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ))))),
                const SizedBox(height: 30),
                // About the App Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.teal[400], size: 28),
                            SizedBox(width: 10),
                              Text("About NotesNeo", 
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                            "NotesNeo is your ultimate study companion, designed specifically for engineering students. Our mission is to provide high-quality, organized, and easily accessible study materials to help you excel in your academics.",
                            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                        ),
                        SizedBox(height: 20),
                        _buildAboutFeature(Icons.library_books, "Comprehensive Notes", "Access unit-wise notes for all semesters."),
                        _buildAboutFeature(Icons.offline_pin, "Easy Access", "Download and study anytime, anywhere."),
                        _buildAboutFeature(Icons.update, "Regular Updates", "Stay updated with the latest curriculum."),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Text("Version : 2.0.0",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)),
                      SizedBox(height: 5),
                      Text("Made with ❤️ for Students", 
                        style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
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
              final User? currentUser = FirebaseAuth.instance.currentUser;
              
              final Map<String, dynamic>? profile = snapshot.data?.data();

              // Use FirebaseAuth data as primary fallback for immediate display
              final String image = (profile?['photoUrl'] ?? currentUser?.photoURL ?? '').toString();
              final String displayName = (profile?['name'] ?? currentUser?.displayName ?? 'Guest').toString();
              final String displayEmail = (profile?['email'] ?? currentUser?.email ?? '').toString();

              return Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3.8,
                        decoration: BoxDecoration(color: Colors.teal[400]),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 13,
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
                                      child: (image == "null" || image.isEmpty)
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
                                    displayName.toUpperCase(),
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
                                    displayEmail,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      // B.Tech and Share Opinion items removed per request
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 19,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 12,
                            top: MediaQuery.of(context).size.height / 47),
                        child: GestureDetector(
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirm logout'),
                                  content: Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: Text('Logout'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                // Close the drawer before logging out
                                Navigator.of(context).pop();
                                await logout();
                              }
                            },
                            child: Text("Logout",
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
                        child: Center(
                            child: Text("Version : 1.0.0",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ]),
              );
            }),
      )),
    );
  }
}