import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtualoffice/pages/create_room.dart';
import 'package:virtualoffice/utils/style_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtualoffice/widgets/login_widget.dart';
import 'package:flutter/material.dart';

class SignupWidget extends StatefulWidget {
  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _firstNameInputController;
  TextEditingController _lastNameInputController;
  TextEditingController _emailInputController;
  TextEditingController _passwordInputController;

  @override
  void initState() {
    _firstNameInputController = new TextEditingController();
    _lastNameInputController = new TextEditingController();
    _emailInputController = new TextEditingController();
    _passwordInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length < 8) {
      return 'Password length must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Container(
                  height: 7*MediaQuery.of(context).size.height/8,
                  decoration: BoxDecoration(),
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: <Widget>[
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          'Sign Up',
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
                                    controller: _firstNameInputController,
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
                                      hintText: 'First Name',
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
                                  alignment: Alignment.centerLeft,
                                  decoration: StyleConstants.loginBoxDecorationStyle,
                                  height: 60.0,
                                  child: TextFormField(
                                    controller: _lastNameInputController,
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
                                      hintText: 'Last Name',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: StyleConstants.loginBoxDecorationStyle,
                                  height: 60.0,
                                  child: TextFormField(
                                    controller: _emailInputController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Enter your Email',
                                      hintStyle: StyleConstants.loginHintTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: StyleConstants.loginBoxDecorationStyle,
                                  height: 60.0,
                                  child: TextFormField(
                                    controller: _passwordInputController,
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Enter your Password',
                                      hintStyle: StyleConstants.loginHintTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: _emailInputController.text,
                                password: _passwordInputController.text)
                                .then((currentUser) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.user.uid)
                                  .set({
                                'firstName': _firstNameInputController.text,
                                'lastName': _lastNameInputController.text,
                                'uid': currentUser.user.uid,
                                'email': _emailInputController.text,
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateRoom()),
                              );
                            }).catchError((e) {
                              print(e.toString());
                              if(e.toString()=='[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'User With Email Already Exists',
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                              if(e.toString()=='[firebase_auth/invalid-email] The email address is badly formatted.') {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Invalid Email',
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                            });
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
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          child: Text('Login'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => (LoginWidget())),
                            );
                          },
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
