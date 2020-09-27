import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtualoffice/widgets/receivedmessagewidget.dart';

class Chat extends StatefulWidget {

  final chatId;

  const Chat({Key key, this.chatId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController textControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    stream: FirebaseFirestore.instance.collection('chat').doc(widget.chatId).collection('history').snapshots(),
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
  }

  Future sendMessage(String message) async {
    print("SENDING MESSAGE");
    textControl.clear();
    await FirebaseFirestore.instance.collection('chat').doc(widget.chatId).collection('history').doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
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
}
