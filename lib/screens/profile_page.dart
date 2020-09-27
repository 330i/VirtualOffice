import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List fullHobbies;

  ProfilePage(String name, List hobbies) {
    fullHobbies = hobbies;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get(),
      builder: (context, snapshot) {
        if(snapshot.data==null) {
          return Scaffold(
            body: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        else {
          DocumentSnapshot doc = snapshot.data;
          return Scaffold(
              body: new Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(color: Colors.blue),
                    clipper: getClipper(),
                  ),
                  Positioned(
                      width: MediaQuery.of(context).size.width,
                      top: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(doc.data()['url']),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 7.0, color: Colors.black)
                                  ])),
                          SizedBox(height: 90.0),
                          Text(
                            doc.data()['name'],
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Futura'),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            'Running, Cooking, Programming',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Futura',
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 25.0),
                          Container(
                              height: 30.0,
                              width: 140.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.greenAccent,
                                color: Colors.green,
                                elevation: 7.0,
                                child: FlatButton(
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      'Edit Your Profile',
                                      style: TextStyle(
                                          color: Colors.white, fontFamily: 'Futura'),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: 25.0),
                          Container(
                              height: 30.0,
                              width: 95.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.redAccent,
                                color: Colors.red,
                                elevation: 7.0,
                                child: FlatButton(
                                  onPressed: () {
                                    debugPrint("Click");
                                  },
                                  child: Center(
                                    child: Text(
                                      'Log out',
                                      style: TextStyle(
                                          color: Colors.white, fontFamily: 'Futura'),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ))
                ],
              ));
        }
      },
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
