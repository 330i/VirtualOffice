import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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

  List _items = [];
  List<bool> tagEnabled = [];

  @override
  Widget build(BuildContext context) {

    bool empty = false;
    print(_items.toString());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Container(
                height: 500,
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
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
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
                                      color: empty ? Colors.red : Colors.black,
                                    ),
                                    hintText: empty ? 'Please Input a Valid Name' : 'Room Name',
                                    hintStyle: StyleConstants.loginHintTextStyle,
                                  ),
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
                          Wrap(
                            children: [
                              Container(
                                child: Container(
                                  child: Wrap(
                                    children: [
                                      Tags(
                                        itemCount: _items.length, // required
                                        itemBuilder: (int index){
                                          return ItemTags(
                                            key: Key(index.toString()),
                                            index: index, // required
                                            title: _items[index],
                                            textStyle: TextStyle( fontSize: 15, ),
                                            combine: ItemTagsCombine.withTextBefore,
                                            removeButton: ItemTagsRemoveButton(
                                              onRemoved: (){
                                                // Remove the item from the data source.
                                                setState(() {
                                                  // required
                                                  _items.removeAt(index);
                                                  tagEnabled.removeAt(index);
                                                });
                                                //required
                                                return true;
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Container(
                            height: 40,
                            width: 200,
                            child: RaisedButton(
                              child: Text(
                                'Add Category',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                                ),
                              ),
                              color: Colors.transparent,
                              focusColor: Colors.transparent,
                              onPressed: () {
                                print(_items.toString());
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  child: AlertDialog(
                                    content: Container(
                                      height: 450,
                                      child: FutureBuilder(
                                        future: FirebaseFirestore.instance.collection('appresource').doc('tags').get(),
                                        builder: (context, snapshot) {
                                          if(snapshot.data==null) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          else {
                                            DocumentSnapshot tagDoc = snapshot.data;
                                            List tag = tagDoc.data()['tags'];
                                            for(int i=0;i<tag.length;i++) {
                                              tagEnabled.add(false);
                                            }
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return ListView.builder(
                                                  itemCount: tag.length,
                                                  itemBuilder: (context, i) {
                                                    if(_items.contains(tag[i])) {
                                                      tagEnabled[i] = true;
                                                    }
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: CheckboxListTile(
                                                            controlAffinity: ListTileControlAffinity.leading,
                                                            value: tagEnabled[i],
                                                            onChanged: (tagChange) {
                                                              setState(() {
                                                                if(tagChange) {
                                                                  _items.add(tag[i]);
                                                                }
                                                                else if(!tagChange) {
                                                                  _items.remove(tag[i]);
                                                                }
                                                                tagEnabled[i] = tagChange;
                                                                print(_items.toString());
                                                              });
                                                            },
                                                            title: Text(
                                                              tag[i],
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
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _items = _items;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          print('tap');
                          if(_roomNameInputController.text.length>0) {
                            onJoin();
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
                              "Create Room",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                )
            ),
          ),
        ),
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
    DocumentReference doc = FirebaseFirestore.instance.collection('rooms').doc();
    doc.set({
      'name': _roomNameInputController.text,
      'roomid': roomid,
      'private': _isPrivate,
      'randomavailable': _isRandom,
      'participantid': [FirebaseAuth.instance.currentUser.uid],
      'startTime': DateTime.now(),
      'category': _items,
    });
    print(roomid);
    _handleCameraAndMic();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: roomid,
          role: ClientRole.Broadcaster,
          roomDocID: doc.id,
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
