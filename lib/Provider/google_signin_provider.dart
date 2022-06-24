import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress2/Model/member_model.dart';

class GoogleSigninProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount getUser() {
    return _user!;
  }

  Future login({required String email, required String pass}) async {
    try {
      Query<Map<String, dynamic>> filter = FirebaseFirestore.instance
          .collection("members")
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: pass);
      final QuerySnapshot<Map<String, dynamic>> result = await filter.get();
      List<Member> data = result.docs
          .map(
            (e) => Member(
              allowed: e.data()['allowed'],
              email: e.data()['email'],
              fullname: e.data()['fullname'],
              imageUrl: e.data()['imageUrl'],
              isAdmin: e.data()['isAdmin'],
              mobile: e.data()['mobile'],
              password: e.data()['password'],
              id: e.id,
            ),
          )
          .toList();

      return data.first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    return cred.additionalUserInfo!.profile;
  }

  Future emailSignUp(String? email, String? password) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.signOut();
    notifyListeners();
  }
}
