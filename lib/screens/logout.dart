import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';

class LogOutScreen extends StatefulWidget {
  static const routName = '/logout';

  @override
  _LogOutScreenState createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyHomePage());
  }
}
