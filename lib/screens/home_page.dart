import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:virtualoffice/pages/call.dart';
import 'package:virtualoffice/themes/colors.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:virtualoffice/screens/preference.dart';
import 'package:virtualoffice/utils/style_constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController meetingNumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  height: 100,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Join a meeting",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: StyleConstants.loginBoxDecorationStyle,
                        height: 60.0,
                        child: TextFormField(
                          controller: meetingNumController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            hintText: 'Room Name',
                            hintStyle: StyleConstants.loginHintTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              GestureDetector(
                onTap: () async {
                  print('tap');
                  QueryDocumentSnapshot roomUID;
                  QuerySnapshot roomSearch = await FirebaseFirestore.instance.collection('rooms').where('roomid').get();
                  roomUID = roomSearch.docs.last;
                  if(meetingNumController.text.length>0&&roomUID!=null) {
                    onJoinRoom(roomUID.id, roomUID.data()['roomid']);
                  }
                  else {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Room Cannot Be Found'),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      "Join Room",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  print('tap');
                  QueryDocumentSnapshot roomUID;
                  var rng = new Random();
                  QuerySnapshot roomSearch = await FirebaseFirestore.instance.collection('rooms').get();
                  roomUID = roomSearch.docs[rng.nextInt(roomSearch.docs.length)];
                  onJoinRoom(roomUID.id, roomUID.data()['roomid']);
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      "Join Random",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> onJoinRoom(String roomID, String roomName) async {
    String roomid = roomID;
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomID)
        .set({
      'participantid': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid.toString()]),
    });
    print(roomid);
    _handleCameraAndMic();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: roomName,
          role: ClientRole.Broadcaster,
          roomDocID: roomID,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
