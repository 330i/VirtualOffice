import 'package:flutter/material.dart';
import 'package:virtualoffice/themes/colors.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  String date = "09/25/2020";
  String name = "Barry Macokiner";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              topBar(width),
              SizedBox(height: 20),
              Text(
                "Meeting History",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 5),
              meetingHistory(date),
              SizedBox(height: 20),
              Text(
                "Friends list",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 5),
              friendsList(name)
            ]
          ),
        ],
      ),
    );
  }

  Widget topBar (double w) {
    return SafeArea(
      child: Container(
        height: 60,
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Community Hub",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 1,
            ),
            FlatButton(
              minWidth: 30,
              onPressed: () {

              },
              child: Icon(
                Icons.chat_outlined,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container meetingHistory(String date){
    return Container(
      child: ListView(
        children: [
          Container(
            child: FlatButton(
              child: Text(
                      "$date",
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
              onPressed: () {},
            ),
          )
        ],
      ),
      height: 200,
      width: 250,
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black),
          color: Colors.grey[300]
      ),
    );
  }






  Container friendsList(String name){
    return Container(
      child: ListView(
        children: [
          Container(
            child: FlatButton(
              child: Text(
                "$name",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
      height: 200,
      width: 250,
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.black),
          color: Colors.grey[300]
      ),
    );
  }





}


