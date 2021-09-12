import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/add_movies.dart';
import 'package:movies_app/helpers/helpersfunctions.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:movies_app/screens/logout.dart';
import 'package:movies_app/widget/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLogIn = false;
  getUserLogInState() async {
    return await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        isUserLogIn = value!;
      });
    });
  }

  @override
  void initState() {
    getUserLogInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      // ignore: unnecessary_null_comparison
      home: isUserLogIn != null
          ? isUserLogIn
              ? LogOutScreen()
              : Authenticate()
          : Authenticate(),
      routes: {
        LogOutScreen.routName: (context) => LogOutScreen(),
        AddMovies.routeName: (context) => AddMovies(),
        MyHomePage.routeName: (context) => MyHomePage()
      },
    );
  }
}
