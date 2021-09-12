import 'package:movies_app/screens/logout.dart';
import '../helpers/helpersfunctions.dart';
import '../helpers/auth.dart';
import "../helpers/database.dart";
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DataBase dataBase = DataBase();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfo = {
        "name": userName.text,
        "email": email.text
      };
      HelperFunctions.saveUserName(userName.text);
      HelperFunctions.saveUserEmail(email.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(email.text, password.text)
          .then((_) {
        HelperFunctions.saveUserLoggedIn(true);
        isLoading = false;

        dataBase.uploadUserInfo(userInfo);
        Navigator.of(context).pushReplacementNamed(LogOutScreen.routName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.black45),
                padding: EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.center,
                child: Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (val) {
                            return (val!.isEmpty || val.length < 2
                                ? "Please Provide a Proper UserName"
                                : null);
                          },
                          controller: userName,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Enter Your Username",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter correct email";
                          },
                          controller: email,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Enter Your Email",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                            controller: password,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Create Your Password",
                              hintStyle: TextStyle(color: Colors.white),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            signMeUp();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(30)),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("Sign Up"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            authMethods.signInWithGoogle().then((value) {
                              dataBase.uploadUserInfo(value);
                              HelperFunctions.saveUserName(value["name"]);
                              Navigator.of(context)
                                  .pushReplacementNamed(LogOutScreen.routName);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("Sign Up With Google"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already Have A Account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                child: Text(
                                  " Login Here",
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
              ),
            ),
    );
  }
}
