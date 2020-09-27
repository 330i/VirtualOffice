import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtualoffice/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:virtualoffice/screens/login_page.dart';
import 'package:virtualoffice/utils/style_constants.dart';
import 'package:virtualoffice/widgets/bottom_bar.dart';


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  File _image;

  @override
  void initState() {
    super.initState();
    nameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
  }

  final image = ImagePicker();

  Future getImage() async {
    PickedFile pickedImage;
    showDialog(
      context: context,
      child: AlertDialog(
        content: Container(
          height: 96,
          child: Column(
            children: [
              FlatButton(
                child: Container(
                  height: 30,
                  child: Text('From Files'),
                ),
                onPressed: () async {
                  pickedImage = await image.getImage(source: ImageSource.gallery);
                  print('img selected');
                  setState(() {
                    _image = File(pickedImage.path);
                    print(_image!=null);
                  });
                },
              ),
              FlatButton(
                child: Container(
                  height: 30,
                  child: Text('From Camera'),
                ),
                onPressed: () async {
                  pickedImage = await image.getImage(source: ImageSource.camera);
                  print('img selected');
                  setState(() {
                    _image = File(pickedImage.path);
                    print(_image!=null);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
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
    }
    else {
      return null;
    }
  }

  FirebaseStorage firebaseStorage = FirebaseStorage(storageBucket: 'gs://virtualoffice-36d78.appspot.com/');
  StorageUploadTask storageUploadTask;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //SizedBox(height: 20.0,),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                        child: Text('Name',
                            style: TextStyle(
                                fontSize: 70.0, fontWeight: FontWeight.w200, color: Colors.black)),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 125.0, 0.0, 0.0),
                        child: Text('Sign up',
                            style: TextStyle(
                                fontSize: 40.0, fontWeight: FontWeight.w600, color: Colors.black)),

                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),

                Row(
                  children: <Widget>[
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey[400],
                        child: _image!=null ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: FileImage(_image),
                                )
                            ),
                          ),
                        ):
                        Icon(Icons.add_a_photo, size: 40.0, color: Colors.white,),
                      ),
                    ),
                    Spacer()
                  ],
                ),

                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
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
                                  controller: nameInputController,
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
                                    hintText: 'Name',
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
                              SizedBox(height: 15.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: StyleConstants.loginBoxDecorationStyle,
                                height: 60.0,
                                child: TextFormField(
                                  controller: emailInputController,
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
                                    hintText: 'Email',
                                    hintStyle: StyleConstants.loginHintTextStyle,
                                  ),
                                  validator: emailValidator,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 15.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: StyleConstants.loginBoxDecorationStyle,
                                height: 60.0,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: passwordInputController,
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
                                    hintText: 'Password',
                                    hintStyle: StyleConstants.loginHintTextStyle,
                                  ),
                                  validator: passwordValidator,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                              onTap: () {
                                if(nameInputController.text.length>0&&passwordValidator(passwordInputController.text)==null&&emailValidator(emailInputController.text)==null) {
                                  print("HELLO");
                                  setState(() {
                                    storageUploadTask = firebaseStorage.ref().child('photos/${DateTime.now().millisecondsSinceEpoch}.png').putFile(_image);
                                  });
                                  FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInputController.text, password: passwordInputController.text).then(
                                          (currentUser) async {
                                        String url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
                                        String pic_url = url.toString();
                                        FirebaseFirestore.instance.collection('users').doc(currentUser.user.uid).set({
                                          "name":nameInputController.text,
                                          "email":emailInputController.text,
                                          "uid":currentUser.user.uid,
                                          "url":pic_url
                                        });
                                      });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BottomBar()),
                                  );
                                }
                              },
                              child: Container(
                                height: 50.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(25.0),
                                  shadowColor: Colors.blue,
                                  color: Colors.black,
                                  elevation: 5.0,
                                  child: Center(
                                    child: Text(
                                      'SIGNUP',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )),

                Container(
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                    child: Text('Login'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => (LoginScreen())),
                      );
                    },
                  ),
                ),
              ]),
        ));
  }
}