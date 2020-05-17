import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gareebgram/pages/CameraPage.dart';
import 'package:gareebgram/pages/Videosharepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'PhotoUploadPage.dart';
import 'package:gareebgram/pages/TimelinePage.dart';

import 'GoogleSignApp.dart';

class HomePage extends StatefulWidget {
   final UserDetails detailsUser;

   HomePage({Key key, @required this.detailsUser}) : super(key: key);  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GoogleSignIn _gSignIn =  GoogleSignIn();


  int _currentIndex=0;
  final List<Widget>_children=[
    TimelinePage(),
    Videosharepage(),
    PhotoUploadPage(),
    CameraPage()
  ];

  void onTapbar(int index) 
  {
    setState(() {
      _currentIndex=index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body: _children[_currentIndex],
      bottomNavigationBar:BottomNavigationBar(
        currentIndex:_currentIndex,
        items: 
        [
          BottomNavigationBarItem
          (
            icon: Icon(Icons.image),
            title: Text("Images"),
            backgroundColor:  Color(0xff2E6873)
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.video_library),
            title: Text("Videos"),
            backgroundColor:  Color(0xff2E6873)
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.file_upload),
            title: Text("Image upload"),
            backgroundColor:  Color(0xff2E6873)
          ),
          BottomNavigationBarItem
          (
            icon: Icon(Icons.video_label),
            title: Text("Video upload"),
            backgroundColor: Color(0xff2E6873)
          ),
        ],
        onTap:onTapbar,
      ),
      ),
    );
  }
}



