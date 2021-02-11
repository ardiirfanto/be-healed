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
          'role': 'klien',
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

  static void updateEmail(String _email) async {
    var message;
    FirebaseUser firebaseUser = await _auth.currentUser();
    firebaseUser
        .updateEmail(_email)
        .then(
          (value) => message = 'Berhasil',
        )
        .catchError((onError) => message = 'gagal');
    return message;
  }

  static void updatePassword(String _password) async {
    var message;
    FirebaseUser firebaseUser = await _auth.currentUser();
    firebaseUser
        .updatePassword(_password)
        .then(
          (value) => message = 'Berhasil',
        )
        .catchError((onError) => message = 'gagal');
    return message;
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error = " + e.toString());
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          Fluttertoast.showToast(
            msg: "Password is wrong, please enter the correct password",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.purple[50],
            fontSize: 16.0,
          );
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          Fluttertoast.showToast(
            msg: "No internet connection, try again later",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.purple[50],
            fontSize: 16.0,
          );
          break;
        case "ERROR_USER_NOT_FOUND":
          Fluttertoast.showToast(
            msg: "User doesn't exist, please sign up",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.purple[50],
            fontSize: 16.0,
          );
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          Fluttertoast.showToast(
            msg: "Too many requests, try again later",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.purple[50],
            fontSize: 16.0,
          );
          break;
        default:
      }
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
