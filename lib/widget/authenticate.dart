import '../screens/sign_in.dart';
import '../screens/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showScreen = false;
  void toggleScreen() {
    setState(() {
      showScreen = !showScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showScreen) {
      return SignIn(toggleScreen);
    } else {
      return SignUp(toggleScreen);
    }
  }
}
