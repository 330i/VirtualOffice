import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:virtualoffice/pages/create_room.dart';
import 'package:virtualoffice/screens/community_page.dart';
import 'package:virtualoffice/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:virtualoffice/themes/colors.dart';
import 'package:virtualoffice/screens/profile_page.dart';

class MeetingBar extends StatefulWidget {
  @override
  _MeetingBarState createState() => _MeetingBarState();
}

class _MeetingBarState extends State<MeetingBar> {
  int pageIndex = 0;

  List<Widget> screens = [HomePage(), CreateRoom()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(
              tabs: [
                Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Text(
                      "Join",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
            body: TabBarView(
              children: [
                HomePage(),
                CreateRoom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}