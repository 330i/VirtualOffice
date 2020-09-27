import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtualoffice/widgets/bottom_bar.dart';
import 'package:virtualoffice/widgets/receivedmessagewidget.dart';

import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  final String roomDocID;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName, this.role, this.roomDocID}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  static final _sessions = List<VideoSession>();
  TextEditingController textControl = new TextEditingController();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    
    super.dispose();
  }
  
  Future<bool> exitCall() async {
    bool pop = true;
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Leave Meeting'),
        content: Text('Are you sure you want to leave the office.'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () {
              pop = false;
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              DocumentSnapshot doc = await FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).get();
              List users = await doc.data()['participantid'];
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid.toString())
                  .collection('history')
                  .doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
                'date': DateTime.now(),
                'participantid': users,
              });
              if(users.length>1) {
                await FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).set({
                  'participantid': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid.toString()]),
                }, SetOptions(merge: true));
              }
              else {
                await FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).delete();
              }
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
                  ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );

    return pop;
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(360, 360);
    AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    AgoraRtcEngine.joinChannel('', widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    AgoraRtcEngine.setClientRole(widget.role);
  }

  final _remoteUsers = List<int>();
  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _remoteUsers.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
          child: Column(
            children: <Widget>[_videoView(views[0])],
          ),
        );
      case 2:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow([views[0]]),
              _expandedVideoRow([views[1]])
            ],
          ),
        );
      case 3:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 3))
            ],
          ),
        );
      case 4:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, 2)),
              _expandedVideoRow(views.sublist(2, 4))
            ],
          ),
        );
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 43,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              height: 43,
              child: FloatingActionButton(
                heroTag: 'btn1',
                onPressed: () {
                  _message();
                },
                child: Icon(
                  Icons.chat,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              height: 43,
              child: FloatingActionButton(
                heroTag: 'btn2',
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                backgroundColor: muted ? Colors.red : Colors.white,
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () => exitCall(),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              height: 43,
              child: FloatingActionButton(
                heroTag: 'btn3',
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              height: 43,
              child: FloatingActionButton(
                heroTag: 'btn4',
                onPressed: () {
                  _onTapInfo();
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _message() {
    showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Group Chat',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).collection('chat').snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.data!=null) {
                              QuerySnapshot snap = snapshot.data;
                              return Scaffold(
                                body: ListView.builder(
                                  itemCount: snap.size,
                                  reverse: true,
                                  itemBuilder: (context, int i) {
                                    DocumentSnapshot doc = snap.docs[snap.size-1-i];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: FutureBuilder(
                                        future: FirebaseFirestore.instance.collection('users').doc(doc.data()['from']).get(),
                                        builder: (context, snapUser) {
                                          DocumentSnapshot user = snapUser.data;
                                          if(snapUser.data!=null) {
                                            return ReceivedMessagesWidget(
                                              message: doc.data()['received'],
                                              imageUrl: user.data()['url'],
                                              name: user.data()['name'],
                                            );
                                          }
                                          else {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.all(15.0),
                      height: 61,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35.0),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: textControl,
                                      decoration: InputDecoration(
                                          hintText: "Text Message",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        sendMessage(textControl.text);
                                      }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future sendMessage(String message) async {
    print("SENDING MESSAGE");
    textControl.clear();
    await FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).collection('chat').doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'from': FirebaseAuth.instance.currentUser.uid,
      'received': message,
    });
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  ScrollController scrollController = ScrollController();

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  void _onTapInfo() async {
    DocumentSnapshot streamDocs = await FirebaseFirestore.instance.collection('rooms').doc(widget.roomDocID).get();
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Room Information'),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Text('Server Name: ${streamDocs.data()['name']}', textAlign: TextAlign.center,),
              Container(height: 10,),
              Text('Join Code: ${streamDocs.data()['roomid']}', textAlign: TextAlign.center,),
              Container(height: 10,),
              Text('Private: ${streamDocs.data()['private']}', textAlign: TextAlign.center,),
              Container(height: 10,),
              Text('Random: ${streamDocs.data()['randomavailable']}', textAlign: TextAlign.center,),
              Container(height: 10,),
              Text('Start Time: ${(streamDocs.data()['startTime'] as Timestamp).toDate()}', textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: exitCall,
        child: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _panel(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}