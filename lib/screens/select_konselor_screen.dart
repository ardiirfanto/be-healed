import 'dart:ui';
import 'package:be_healed/screens/chat_screen.dart';
import 'package:be_healed/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SelectKonselorScreen extends StatefulWidget {
  final String currentUserId;
  SelectKonselorScreen({Key key, @required this.currentUserId})
      : super(key: key);

  @override
  State createState() =>
      SelectKonselorScreenState(currentUserId: currentUserId);
}

class SelectKonselorScreenState extends State<SelectKonselorScreen> {
  SelectKonselorScreenState({Key key, @required this.currentUserId, this.user});

  final String currentUserId;
  bool isLoading = false;

  final FirebaseUser user;

  final double appBarHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pilih Konselor',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 25.0,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: usersRef.document(currentUserId).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return Container(
              child: Stack(
                children: <Widget>[
                  // List
                  Container(
                    color: Colors.white,
                    child: StreamBuilder(
                      stream: usersRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SpinKitRing(
                              color: Colors.deepPurple,
                              size: 25.0,
                              lineWidth: 3.0,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(
                                context, snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                          );
                        }
                      },
                    ),
                  ),

                  // Loading
                  Positioned(
                    child: isLoading
                        ? const Center(
                            child: SpinKitRing(
                              color: Colors.deepPurple,
                              size: 25.0,
                              lineWidth: 3.0,
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['role'] == 'klien') {
      return Container();
    } else {
      return Container(
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Material(
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.black,
                  backgroundImage: document['profileImageUrl'].isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : CachedNetworkImageProvider(document['profileImageUrl']),
                ),
                // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                // clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document['name']}',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${document['bio'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          receiverId: document.documentID,
                          receiverAvatar: document['profileImageUrl'],
                          receiverName: document['name'],
                          receiverToken: document['FCMToken'],
                          chatId: null,
                          currentUserId: currentUserId,
                          id: currentUserId,
                        )));
          },
        ),
        margin: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
      );
    }
  }
}
