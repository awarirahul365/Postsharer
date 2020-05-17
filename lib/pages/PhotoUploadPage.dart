import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gareebgram/pages/GoogleSignApp.dart';
import 'package:gareebgram/pages/HomePage.dart';
import 'package:gareebgram/pages/TimelinePage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PhotoUploadPage extends StatefulWidget {
  
  @override
  _PhotoUploadPageState createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {

  File sampleimage;
  String _myvalue;
  String _myvaluea;
  var url;
  final formKey =new GlobalKey<FormState>();

  Future getimage() async{
    var tempimage=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleimage=tempimage;
    });
  }
  void uploadmemeimage()async{

    if(validateandsave())
    {
      final StorageReference postimage=FirebaseStorage.instance.ref().child("POST IMAGES");

      var timekey = new DateTime.now();

      final StorageUploadTask uploadTask=postimage.child(timekey.toString()+".jpg").putFile(sampleimage);

      var Imageurl=await (await uploadTask.onComplete).ref.getDownloadURL();

      url=Imageurl.toString();

      print(url);

      gotohomepage();

      saveTodatabase(url);

    }
  }
  void saveTodatabase(url)
  {
     var dbtimekey = new DateTime.now();
     var formatDate=new DateFormat('MMM d, yyyy');
     var formatTime=new DateFormat('EEEE, hh:mm:aaa');

     String date=formatDate.format(dbtimekey);
     String time=formatTime.format(dbtimekey);

     DatabaseReference ref=FirebaseDatabase.instance.reference();

     var data=
     {
       "image":url,
       "description":_myvalue,
       "date":date,
       "time":time,
       "author":_myvaluea,
     };
     ref.child("Posts").push().set(data);
  
  }
  void gotohomepage(){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
  }

  bool validateandsave(){
    final form=formKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }

  }

  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("UPLOAD IMAGE"),
        backgroundColor:Color(0xff2E6873),
      ),
      body: Center(
        child: sampleimage==null?Text("Select Image",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),):enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:getimage,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
         ),
    );
  }
  Widget enableUpload(){
    return SingleChildScrollView(
      child: Container(
      child: Form(
      key:formKey,
      child: Column(
        children:<Widget>[
          Image.file(sampleimage,height:330,width:330),

          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: new InputDecoration(
              labelText:"Description",
              border: OutlineInputBorder(),
              ),
            validator: (value){
              return value.isEmpty?"Write Something ":null;
            },
            onSaved: (value){
              _myvalue=value;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: new InputDecoration(
              labelText:"Author",
              border: OutlineInputBorder(),
              ),
            validator: (valuea){
              return valuea.isEmpty?"Write Something ":null;
            },
            onSaved: (valuea){
              _myvaluea=valuea;
            },
          ),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.black,
            onPressed: uploadmemeimage,
            child: Text("UPLOAD IMAGE"),
          )
        ]
      ),
    ),
    ),
    );
  }
}


