import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:be_healed/models/user_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(BuildContext context, String name, String email,
      String phoneNumber, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'id': signedInUser.uid,
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'age': '',
          'gender': '',
          'address': '',
          'bio': '',
          'profileImageUrl': '',
          'role': '',
          'chattingWith': null,
        });
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error = " + e.toString(),
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.purple[50],
        fontSize: 16.0,
      );
    }
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error = " + e.toString());
      Fluttertoast.showToast(
        msg: "Email or password is wrong, try again",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.purple[50],
        fontSize: 16.0,
      );
    }
  }

  // static void authorizeAccess(BuildContext context) {
  //   _auth.currentUser().then((usersRef) {
  //     _firestore
  //         .collection('/users')
  //         .where('uid', isEqualTo: usersRef.uid)
  //         .getDocuments()
  //         .then((docs) {
  //       if (docs.documents[0].exists) {
  //         if (docs.documents[0].data['role'] == 'konselor') {
  //           return ChatScreenKonselor();
  //           // Navigator.of(context).push(new MaterialPageRoute(
  //           //     builder: (BuildContext context) => new (ChatScreenKonselor)));
  //         }
  //       } else {
  //         return ChatScreenKlien();
  //       }
  //     });
  //   });
  // }

  static void logout() {
    _auth.signOut();
  }
}
