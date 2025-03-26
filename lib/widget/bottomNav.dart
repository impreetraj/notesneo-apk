import 'package:deepaknote/widget/book.dart';
import 'package:deepaknote/widget/fav.dart';
import 'package:deepaknote/widget/homePage.dart';
import 'package:flutter/material.dart';


class BottomNav extends StatefulWidget {
  
      const BottomNav({super.key});
 
 

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  List screen = [HomePage(),Book(),  Favourite()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: "Study Material"),
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: "Download"),
         
        ],
      ),
    );
  }
}
