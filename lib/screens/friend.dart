import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtualoffice/screens/chat.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Friends',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('friends').get(),
        builder: (context, snapUser) {
          QuerySnapshot user = snapUser.data;
          if(snapUser.data!=null) {
            return ListView.builder(
              itemCount: user.docs.length,
              itemBuilder: (context, int i) {
                return FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Chat(chatId: user.docs[i].data()['chatuid']);
                    }));
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Container(width: 10,),
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('users').doc(user.docs[i].data()['uid']).get(),
                          builder: (context, snapFriend) {
                            if(snapFriend.data!=null) {
                              DocumentSnapshot friend = snapFriend.data;
                              return Container(
                                width: 36,
                                height: 36,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          alignment: FractionalOffset.topCenter,
                                          image: NetworkImage(friend.data()['url']),
                                        )
                                    ),
                                  ),
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
                        Container(width: 10,),
                        Text(
                          user.docs[i].data()['name'],
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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
  }
}
