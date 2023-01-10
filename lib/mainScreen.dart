//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutterfirebase/firebaseServices/splash_Services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  splashServices MainScreen = splashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MainScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "HELLO FLUTTER",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
