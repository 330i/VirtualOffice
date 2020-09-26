import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtualoffice/pages/call.dart';
import 'package:virtualoffice/utils/style_constants.dart';
import 'package:flutter_tags/flutter_tags.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _roomNameInputController;
  bool _isPrivate;
  bool _isRandom;

  @override
  void initState() {
    _roomNameInputController = new TextEditingController();
    _isPrivate = false;
    _isRandom = false;
    super.initState();
  }

  List _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Container(
            decoration: BoxDecoration(),
            child: Form(
              key: _signUpFormKey,
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Create Room',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  Column(
                    children: <Widget>[
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
                              controller: _roomNameInputController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: 'Room Name',
                                hintStyle: StyleConstants.loginHintTextStyle,
                              ),
                              validator: (input) {
                                if (input.trim().length < 1) {
                                  return "Please input a valid name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Container(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _isPrivate,
                              onChanged: (private) {
                                setState(() {
                                  _isPrivate = private;
                                  private ? _isRandom = false : print('random will stay');
                                });
                                print('private:$private');
                                print('random:$_isRandom');
                              },
                              title: Text(
                                'Private',
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: _isPrivate ?
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _isRandom,
                              onChanged: null,
                              title: Text(
                                'Random',
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            ) :
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _isRandom,
                              onChanged: (random) {
                                setState(() {
                                  _isRandom = random;
                                });
                                print('random:$random');
                              },
                              title: Text(
                                'Random',
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          child: Container(
                            height: 50,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: AlertDialog(
                                content: FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('appresource').doc('tags').get(),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    else {
                                      return ListView.builder(
                                        itemCount: snapshot.data['tags'].length,
                                        itemBuilder: (context, i) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: _isPrivate ?
                                                CheckboxListTile(
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  value: _isRandom,
                                                  onChanged: null,
                                                  title: Text(
                                                    snapshot.data['tags'][i],
                                                    style: TextStyle(
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ) :
                                                CheckboxListTile(
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  value: _isRandom,
                                                  onChanged: (random) {
                                                    setState(() {
                                                      _isRandom = random;
                                                    });
                                                    print('random:$random');
                                                  },
                                                  title: Text(
                                                    'Random',
                                                    style: TextStyle(
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      onJoin();
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
                          "Create Room",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  String _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  String getRandomString() => String.fromCharCodes(Iterable.generate(
      1, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> onJoin() async {
    String roomid = DateTime.now().millisecondsSinceEpoch.toString().substring(12,13)
        +getRandomString()
        +DateTime.now().millisecondsSinceEpoch.toString().substring(10,11)
        +getRandomString()
        +DateTime.now().millisecondsSinceEpoch.toString().substring(8,9)
        +getRandomString()
        +getRandomString();
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc()
        .set({
      'name': _roomNameInputController.text,
      'roomid': roomid,
      'private': _isPrivate,
      'randomavailable': _isRandom,
    });
    print(roomid);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: roomid,
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }
}
