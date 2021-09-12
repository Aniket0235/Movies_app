import '../helpers/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final fa.FirebaseAuth _auth = fa.FirebaseAuth.instance;
  User? _userFromFirebaseUser(dynamic user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      dynamic user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      dynamic firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      await GoogleSignIn().disconnect();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<dynamic, dynamic>> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final fa.AuthCredential credential = fa.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await GoogleSignIn().disconnect();

    final dynamic authResult = await _auth.signInWithCredential(credential);
    // ignore: unused_local_variable
    final dynamic user = authResult.user;
    Map<String, dynamic> userInfo = {
      "name": googleSignInAccount.displayName,
      "email": googleSignInAccount.email
    };
    return userInfo;
  }
}
