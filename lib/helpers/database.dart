import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  Future getUserByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
}
