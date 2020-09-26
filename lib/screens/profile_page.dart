import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName;
  List fullHobbies;

  ProfilePage(String name, List hobbies) {
    fullName = name;
    fullHobbies = hobbies;
  }

  @override
  Widget build(BuildContext context) {
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
                            image: NetworkImage(
                                'https://4.bp.blogspot.com/-0yA9cISY5WM/Wo0z6YjbDMI/AAAAAAAANqw/jAlP7Ge0wII4r0fwMEZESTyHXoAa9ef3gCLcBGAs/s1600/22580975_513736059005363_4184176973922172928_n.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 90.0),
                Text(
                  '$fullName',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Futura'),
                ),
                SizedBox(height: 15.0),
                Text(
                  '$fullHobbies',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Futura',
                      decoration: TextDecoration.underline),
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
