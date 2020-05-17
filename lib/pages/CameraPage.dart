import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gareebgram/pages/GoogleSignApp.dart';
import 'package:gareebgram/pages/HomePage.dart';
import 'package:gareebgram/pages/TimelinePage.dart';
import 'package:gareebgram/pages/Videosharepage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  
  File _video;
  String _myvideovalue;
  var url;
  String _mybidvalue;
  final formnKey =new GlobalKey<FormState>();
  VideoPlayerController _videoPlayerController;
  void _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
     _video = video; 
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
  }
  void uploadvideo()async{
    if(validatesav())
    {
      final StorageReference postvideo=FirebaseStorage.instance.ref().child("POST VIDEO");
      var timekey = new DateTime.now();
      final StorageUploadTask uploadTask=postvideo.child(timekey.toString()+".mp4").putFile(_video);
      var Videourl=await (await uploadTask.onComplete).ref.getDownloadURL();
      url=Videourl.toString();
      print(url);
      gotohomepage();

      savevideoTodatabase(url);

    }
  }
  void savevideoTodatabase(url){
     var dbtimekey = new DateTime.now();
     var formatDate=new DateFormat('MMM d, yyyy');
     var formatTime=new DateFormat('EEEE, hh:mm:aaa');

     String date=formatDate.format(dbtimekey);
     String time=formatTime.format(dbtimekey);

     DatabaseReference ref=FirebaseDatabase.instance.reference();

     var data=
     {
       "video":url,
       "caption":_myvideovalue,
       "date":date,
       "time":time,
       "person":_mybidvalue,
     };
     ref.child("Player").push().set(data);
  }
  bool validatesav(){
    final form=formnKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void gotohomepage(){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Videosharepage()),
  );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
          title:Text("UPLOAD VIDEO"),
          backgroundColor:Color(0xff2E6873),
        ),
        body:Center(
          child:_video==null?Text("Select Video",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),):ableUpload(),
        ), 
        floatingActionButton: FloatingActionButton(
        onPressed:_pickVideo,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
         ),
      ),
    );
  }
  Widget ableUpload(){
    return SingleChildScrollView(
          child:Container(
            child: Form(
              key:formnKey,
              child:Column(
              children:<Widget>[
                if(_video != null) 
                      _videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : Container(),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: new InputDecoration(
                  labelText:"Caption",
                  border: OutlineInputBorder(),
                  
              ),
              validator: (value){
              return value.isEmpty?"Write Something ":null;
            },
            onSaved: (value){
              _myvideovalue=value;
            },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: new InputDecoration(
                  labelText:"Person",
                  border: OutlineInputBorder(),
              ),
              validator: (value){
              return value.isEmpty?"Write Something ":null;
            },
            onSaved: (value){
              _mybidvalue=value;
            },
                ),
                RaisedButton(
                  onPressed: uploadvideo,
                  child:Text("Upload Video"),
                  textColor: Colors.black,
                  color: Colors.blue,
                  )  
              ]
            ), 
              ),
          ),
        );

  }
 
  
}
