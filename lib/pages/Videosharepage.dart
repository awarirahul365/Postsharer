import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gareebgram/widgets/chewie_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';

class Videosharepage extends StatefulWidget {
  @override
  _VideosharepageState createState() => _VideosharepageState();
}

class _VideosharepageState extends State<Videosharepage> {


  List lists=[];
  final dbRef = FirebaseDatabase.instance.reference().child("Player");

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
          title: Text("GG TV"),
          backgroundColor: Color(0xff2E6873),
        ),
        body:Container(
          child: FutureBuilder(
            future: dbRef.once(),
            builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
              if(snapshot.hasData)
              {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                values.forEach((key, values) {
                lists.add(values);
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: lists.length,
                  itemBuilder: (BuildContext context, int index){
                    return ChewieListItem(
                      videoPlayerController: VideoPlayerController.network(
                      lists[index]['video'],
                      ),
                      date: lists[index]['date'],
                    );
                  }
                );
              }
              else{
                return Center(child:CircularProgressIndicator());
              }
            }
          ),
        ),
      ),
    );
  }
}