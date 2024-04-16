import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intime_news/Saved.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intime_news/edit_profile.dart';

import 'News.dart';
import 'Settings.dart';
import 'Tweet.dart';



class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {


  //Navigation Bar Controller
  List<String> items = ['Saved', 'News', 'Settings'];
  List<Widget> screens = [SavedPostsScreen(), News(), Settings()];

  static int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This list holds the data for the list view





  @override
  initState() {
    super.initState();
    _selectedIndex = 1;

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (ModalRoute
              .of(context)
              ?.settings
              .name != '/home') {
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(

            backgroundColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(39, 39, 40, 1),
            unselectedLabelStyle:
            GoogleFonts.raleway(color: const Color.fromRGBO(39, 39, 40, 1)),
            selectedLabelStyle:
            GoogleFonts.raleway(color: const Color.fromRGBO(30, 63, 132, 1)),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Color.fromRGBO(30, 63, 132, 1),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                activeIcon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],


          ),


          body: screens[_selectedIndex],




        ));
  }}