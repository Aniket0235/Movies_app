import 'package:movies_app/screens/logout.dart';
import '../helpers/helpersfunctions.dart';
import '../helpers/auth.dart';
import '../helpers/database.dart';
import '../widget/forget_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  static const routeName = '/signIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods auth = AuthMethods();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  DataBase dataBase = DataBase();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late QuerySnapshot snapshot;
  signIn() {
    if (formKey.currentState!.validate()) {
      auth.signInWithEmailAndPassword(email.text, password.text).then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedIn(true).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(LogOutScreen.routName);
          });
        }
      });
      dataBase.getUserByUserEmail(email.text).then((val) {
        snapshot = val;
        HelperFunctions.saveUserName(snapshot.docs[0].get("name"));
      });
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome Back!"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.black45),
            padding: EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter correct email";
                          },
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "email",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                            controller: password,
                            obscureText: true,
                            validator: (val) {
                              return val!.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "password",
                              hintStyle: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(ForgetPassword.routeName),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(200, 5, 4, 0),
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Sign In"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      auth.signInWithGoogle().then((value) {
                        HelperFunctions.saveUserName(value["name"]);
                        HelperFunctions.saveUserLoggedIn(true).then((value) =>
                            Navigator.of(context)
                                .pushReplacementNamed(LogOutScreen.routName));
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Sign In With Google"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have A Account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          child: Text(
                            " Register Here",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ));
  }
}
