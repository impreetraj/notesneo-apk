import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({super.key});

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.pink,
        
        title: Text("Feedback"), centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("reviews").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  return 
                     ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> FavData =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        String image = FavData['profile'].toString();
                        String name = FavData['name'].toString();
                        String email = FavData['email'].toString();
                        String discrptiion = FavData['review'].toString();

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: (image == "null" || image.isEmpty) 
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.pink.withOpacity(0.1),
                                    child: Icon(Icons.person, color: Colors.pink),
                                  )
                                : Image.network(
                                    image,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
                                  ),
                          ),
                          title: Container(
                            width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
                            child: Text("${name} (${email})" , style: TextStyle(fontWeight: FontWeight.w800),)),
                          subtitle: Text(discrptiion , style: TextStyle(fontWeight: FontWeight.w800)),
                        );
                      },
                    
                  );
                } else {
                  return Center(child: Text("no data"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        
      
    );
  }
}