// import 'dart:convert';
// import 'dart:io';
import 'dart:ui';
import 'package:be_healed/screens/chat_screen.dart';
import 'package:be_healed/screens/select_konselor_screen.dart';
import 'package:be_healed/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;
  ChatListScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => ChatListScreenState(currentUserId: currentUserId);
}

class ChatListScreenState extends State<ChatListScreen> {
  ChatListScreenState({Key key, @required this.currentUserId, this.user});

  final String currentUserId;
  bool isLoading = false;

  final FirebaseUser user;

  final double appBarHeight = 50;
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // @override
  // void initState() {
  //   super.initState();
  //   registerNotification();
  //   configLocalNotification();
  // }

  // void registerNotification() {
  //   firebaseMessaging.requestNotificationPermissions();

  //   firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
  //     print('onMessage: $message');
  //     Platform.isAndroid
  //         ? showNotification(message['notification'])
  //         : showNotification(message['aps']['alert']);
  //     return;
  //   }, onResume: (Map<String, dynamic> message) {
  //     print('onResume: $message');
  //     return;
  //   }, onLaunch: (Map<String, dynamic> message) {
  //     print('onLaunch: $message');
  //     return;
  //   });

  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     usersRef.document(currentUserId).updateData({'pushToken': token});
  //   }).catchError((err) {
  //     Fluttertoast.showToast(msg: err.message.toString());
  //   });
  // }

  // void configLocalNotification() {
  //   var initializationSettingsAndroid =
  //       new AndroidInitializationSettings('app_icon');
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(
  //       initializationSettingsAndroid, initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // void showNotification(message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     Platform.isAndroid ? 'com.example.be_healed' : 'com.example.be_healedtwo',
  //     'be HealEd',
  //     'It\'s okay, to be HealEd',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  //   print(message);

  //   await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
  //       message['body'].toString(), platformChannelSpecifics,
  //       payload: json.encode(message));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Let\'s Chat',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 25.0,
          ),
        ),
      ),
      body: SlidingUpPanel(
        minHeight: 225,
        maxHeight: 450,
        panelBuilder: (scrollController) => Scaffold(
          appBar: buildAppBar(),
          body: StreamBuilder<DocumentSnapshot>(
              stream: usersRef.document(currentUserId).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                return Container(
                  child: Stack(
                    children: <Widget>[
                      // List
                      Container(
                        color: Colors.white,
                        child: checkRole(snapshot.data),
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
        ),
        body: Container(
          color: Colors.lightBlueAccent,
          child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 375.0),
            child: SvgPicture.asset(
              "assets/images/feed.svg",
              height: 150,
            ),
          ),
        ),
      ),
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'klien') {
      return StreamBuilder(
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
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectKonselorScreen(
                      currentUserId: currentUserId,
                    ),
                  ),
                ),
                tooltip: "Mulai Konseling",
                child: Icon(Icons.search_rounded),
              ),
              body: Container(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                ),
              ),
            );
          }
        },
      );
    } else {
      return StreamBuilder(
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
            return Container(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    buildItemKonselor(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              ),
            );
          }
        },
      );
    }
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['role'] == 'klien' ||
        document['role'] == 'konselor' && document['chattingWith'] == '') {
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
                          currentUserId: currentUserId,
                          id: currentUserId,
                        )));
          },
        ),
        margin: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
      );
    }
  }

  Widget buildItemKonselor(BuildContext context, DocumentSnapshot document) {
    if (document['role'] == 'konselor' ||
        document['role'] == 'klien' && document['chattingWith'] == '') {
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
                          currentUserId: currentUserId,
                          id: currentUserId,
                        )));
          },
        ),
        margin: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
      );
    }
  }

  Widget buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Icon(
              Icons.drag_handle_rounded,
              size: 40,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      );
}
