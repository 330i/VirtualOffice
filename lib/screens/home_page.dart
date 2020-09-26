import 'package:flutter/material.dart';
import 'package:virtualoffice/themes/colors.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:virtualoffice/screens/preference.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String meetingNum;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
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
                          "Join or make a meeting",
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  ],
                ),
                decoration: new BoxDecoration(
                  color: LightColors.kBlue,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(60.0),
                      bottomRight: const Radius.circular(60.0)),
                )),
            SizedBox(height: 150),
            AvatarGlow(
                endRadius: 75,
                glowColor: Colors.green,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 1),
                startDelay: Duration(seconds: 1),
                child: RaisedButton(
                    elevation: 25.0,
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: FlutterLogo(
                        size: 100.0,
                      ),
                      radius: 105,
                    )),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: TextFormField(
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Please enter the meeting Id',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.contains('@')
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              Container(
                width: 300,
                child: ButtonTheme(
                  height: 50,
                  child: RaisedButton(
                      color: Colors.lightBlue[100],
                      onPressed: () {
                        navigateToSubPage(context);
                      },
                      child: Text("Make a meeting"),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }
}
