import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessmarketplace/apis/firebase_provider.dart';
import 'package:fitnessmarketplace/helpers/calendar_helper.dart';
import 'package:fitnessmarketplace/helpers/string_helper.dart';
import 'package:fitnessmarketplace/models/PrivateSession.dart';
import 'package:fitnessmarketplace/models/Stream.dart' as models;
import 'package:fitnessmarketplace/models/video_info.dart';
import 'package:fitnessmarketplace/pages/add_new_screen.dart';
import 'package:fitnessmarketplace/pages/add_session_page.dart';
import 'package:fitnessmarketplace/pages/player.dart';
import 'package:fitnessmarketplace/pages/stream_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fitnessmarketplace/models/Trainer.dart';
import 'package:fitnessmarketplace/models/RecordedVideo.dart';

class CalenderWidget extends StatefulWidget {
  @override
  _CalenderWidgetState createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  CalendarController _calendarController;
  Trainer currentTrainer;
  List<RecordedVideo> trainerVideos;
  List<PrivateSession> allPrivateSessions;
  List<dynamic> privateSessions;
  List<VideoInfo> _videos = <VideoInfo>[];
  List<models.Stream> allStreams;
  List<dynamic> selectedStreams;
  DateTime selectedDate;
  List<dynamic> allEvents;

  StringHelper _stringHelper = new StringHelper();
  CalendarHelper _calendarHelper = new CalendarHelper();

  @override
  void initState() {
    FirebaseProvider.listenToVideos((newVideos) {
      setState(() {
        _videos = newVideos;
      });
    });
    selectedDate = DateTime.now();
    _calendarController = CalendarController();
    allEvents = new List<dynamic>();
    setUp();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  setUp() async {
    trainerVideos = new List<RecordedVideo>();
    allPrivateSessions = new List<PrivateSession>();
    privateSessions = new List<PrivateSession>();
    allStreams = new List<models.Stream>();
    selectedStreams = new List<models.Stream>();

    FirebaseUser getUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData = await Firestore.instance
        .collection('trainers')
        .document(getUser.uid)
        .get();
    currentTrainer = Trainer.fromSnapshot(userData);

    await getPrivateSessions();
    await getStreams();
    await getVideos();

    setState(() {});
  }

  getVideos() async {
    QuerySnapshot getVideos =
    await currentTrainer.reference.collection('videos').getDocuments();
    List<DocumentSnapshot> allVideos = getVideos.documents;
    for (int i = 0; i < allVideos.length; i++) {
      trainerVideos.add(RecordedVideo.fromSnapshot(allVideos[i]));
    }
  }

  getPrivateSessions() async {
    allPrivateSessions = new List<PrivateSession>();
    QuerySnapshot getPrivateSessions = await currentTrainer.reference
        .collection('privateSessions')
        .getDocuments();
    List<DocumentSnapshot> allPrivateSessionDocuments =
        getPrivateSessions.documents;
    for (int i = 0; i < allPrivateSessionDocuments.length; i++) {
      allPrivateSessions
          .add(PrivateSession.fromSnapshot(allPrivateSessionDocuments[i]));
    }
  }

  getStreams() async {
    allStreams = new List<models.Stream>();
    QuerySnapshot getStreams =
    await currentTrainer.reference.collection('streams').getDocuments();
    List<DocumentSnapshot> allStreamDocuments = getStreams.documents;
    for (int i = 0; i < allStreamDocuments.length; i++) {
      allStreams.add(models.Stream.fromSnapshot(allStreamDocuments[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentTrainer == null) {
      TrainerHomePage();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Text(
                        'Trainer: ' + currentTrainer.firstName,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {},
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  height: 10.0,
                  thickness: 0.75,
                ),
              ),
              Container(child: _buildCalendar()),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCalendar() {
    return Container(
      //color: Color(0xff465466),
      //color: Colors.white,
      child: TableCalendar(
        rowHeight: 40.0,
        onDaySelected: (DateTime date, List<dynamic> events) {
          for (int i = 0; i < events.length; i++) {
            if (events[i] is PrivateSession) {
              privateSessions.add(events[i]);
            } else if (events[i] is models.Stream) {
              selectedStreams.add(events[i]);
            }
          }
          setState(() {
            selectedDate = date;
            allEvents = events;
          });
        },
        locale: 'en_US',
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.month,
        formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.horizontalSwipe,
        events: _calendarHelper.listToEventMap(allPrivateSessions, allStreams),
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
}