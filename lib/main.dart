import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'screens/sign_up.dart';
import 'screens/home_page.dart';
import 'widgets/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomBar(),
    );
  }
}


