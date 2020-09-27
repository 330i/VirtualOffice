import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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
              SizedBox(height: 10),
              Text(
                "Meeting History",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              _buildCalendar(),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
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

  CalendarController _calendarController = new CalendarController();
  Map<DateTime, List<dynamic>> events = {};

  Map<DateTime, List<dynamic>> getHistory() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('history').get();
    List<QueryDocumentSnapshot> snaps = querySnapshot.docs;
    for(int i=0;i<snaps.length;i++) {
      events.addAll({snaps[i].data()['date']:snaps[i].data()['participantid']});
    }
    return events;
  }

  Widget _buildCalendar() {
    return Container(
      //color: Color(0xff465466),
      //color: Colors.white,
      child: TableCalendar(
        rowHeight: 40.0,
        onDaySelected: (DateTime date, List<dynamic> events) {
        },
        locale: 'en_US',
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.month,
        formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        events: getHistory(),
        availableGestures: AvailableGestures.horizontalSwipe,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        calendarStyle: CalendarStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          weekendStyle: TextStyle(color: Colors.red),
          outsideStyle: TextStyle(color: Colors.grey),
          unavailableStyle: TextStyle(color: Colors.grey),
          outsideWeekendStyle: TextStyle(color: Colors.grey),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextBuilder: (date, locale) {
            return DateFormat.E(locale)
                .format(date)
                .substring(0, 3)
                .toUpperCase();
          },
          weekdayStyle: TextStyle(color: Colors.grey),
          weekendStyle: TextStyle(color: Colors.grey),
        ),
        headerVisible: true,
        headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        builders: CalendarBuilders(
          markersBuilder: (context, date, events, holidays) {
            return [
              Container(
                decoration: new BoxDecoration(
                  color: Color(0xFF30A9B2),
                  //color: Color(C),
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(4.0),
                width: 4,
                height: 4,
              )
            ];
          },
          selectedDayBuilder: (context, date, _) {
            return Container(
              decoration: new BoxDecoration(
                color: Color(0xFF30A9B2),
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(4.0),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
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
                  fontSize: 18,
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


