import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gareebgram/models/Posts.dart';
import 'package:like_button/like_button.dart';


class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  int _itemCount = 0;

  

  List lists=[];
  final dbRef = FirebaseDatabase.instance.reference().child("Posts");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }  


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:Text("POSTS"),
          backgroundColor: Color(0xff2E6873),
        ),
        body:Container(
          child: FutureBuilder(
    future: dbRef.once(),
    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
        lists.clear();
        Map<dynamic, dynamic> values = snapshot.data.value;
        values.forEach((key, values) {
            lists.add(values);
        });
        return new ListView.builder(
            shrinkWrap: true,
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 10.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(lists[index]['date'],style: TextStyle(color:Colors.teal,fontSize:14),),
                        SizedBox(
                          width: 180,
                        ),
                        Text(lists[index]['time'],style: TextStyle(color:Colors.teal,fontSize:14),),
                      ],
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Image.network(
                      lists[index]['image'],
                      width:480,
                      height:270,
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Description: ${lists[index]['description']}",style: TextStyle(color:Colors.teal,fontSize:15,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Author: ${lists[index]['author']}",style: TextStyle(color:Colors.teal,fontSize:15,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      children: <Widget>[
                        LikeButton(
                    size:40 ,
                    circleColor:
                    CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                    return Icon(
                    Icons.thumb_up,
                    color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                   );
                   },
                    likeCount: 0,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                    Widget result;
                  if (count == 0) {
                    result = Text(
                "Like",
                style: TextStyle(color: color),
              );
            } else
              result = Text(
                text,
                style: TextStyle(color: color),
              );
            return result;
          },
        ),
        SizedBox(
          width:15,
        ),
        LikeButton(
                    size:40 ,
                    circleColor:
                    CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                    return Icon(
                    Icons.thumb_down,
                    color: isLiked ? Colors.deepOrange : Colors.grey,
                   );
                   },
                    likeCount: 0,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                    Widget result;
                  if (count == 0) {
                    result = Text(
                "Dislike",
                style: TextStyle(color: color),
              );
            } else
              result = Text(
                text,
                style: TextStyle(color: color),
              );
            return result;
          },
        ),
                      ],
                    ),
                    ] 
                ),
                );
            });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
    }),
        ),
      ),
    );
  }
    
}