import 'package:be_healed/screens/home_screen.dart';
import 'package:be_healed/screens/login_screen.dart';
import 'package:be_healed/screens/signup_screen.dart';
import 'package:be_healed/services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() {
  runApp(BeHealEd());
}

class BeHealEd extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SpinKitRing(
                color: Colors.deepPurple,
                size: 25.0,
                lineWidth: 3.0,
              ),
            ),
          );
        } else {
          if (snapshot.hasData) {
            Provider.of<UserData>(context).currentUserId = snapshot.data.uid;

            // register FirebaseMessagingService disini karena
            // disini sudah dipastikan bahwa user telah login
            // dan sesegera mungkin untuk melakukan inisialisasi
            // kebutuhan firebase messaging
            return ChangeNotifierProvider(
              create: (context) => FirebaseMessagingService(),
              child: HomeScreen(),
            );
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'be HealEd',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Colors.lightBlueAccent,
                ),
            textTheme: GoogleFonts.latoTextTheme()),
        home: _getScreenId(),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
        },
      ),
    );
  }
}
