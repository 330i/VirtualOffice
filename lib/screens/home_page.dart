import 'package:flutter/material.dart';
import 'package:virtualoffice/themes/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: LightColors.kLightYellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200,
            width: width,
            decoration: new BoxDecoration(
              color: LightColors.kDarkBlue,
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(60.0),
                  bottomRight: const Radius.circular(60.0)),
              boxShadow: [
                BoxShadow(
                  color: LightColors.kDarkBlue,
                  spreadRadius: 3,
                  blurRadius:1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            )),
        ],
      ),
    );
  }
}
