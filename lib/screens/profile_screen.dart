import 'dart:ui';
import 'package:be_healed/screens/change_password_screen.dart';
import 'package:be_healed/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:be_healed/models/user_data.dart';
import 'package:be_healed/models/user_model.dart';
import 'package:be_healed/screens/edit_profile_screen.dart';
import 'package:be_healed/services/database_service.dart';
import 'package:be_healed/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User _profileUser;
  final double appBarHeight = 50;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    _setupProfileUser();
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 200.0,
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    user: user,
                    updateUser: (User updateUser) {
                      // Trigger state rebuild after editing profile
                      User updatedUser = User(
                        id: updateUser.id,
                        name: updateUser.name,
                        email: user.email,
                        profileImageUrl: updateUser.profileImageUrl,
                        bio: updateUser.bio,
                      );
                      setState(() => _profileUser = updatedUser);
                    },
                  ),
                ),
              ),
              color: Colors.deepPurple,
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(width: 30.0);
  }

  _buildProfileImage(User user) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.black,
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(user.profileImageUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.all(20.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       CircleAvatar(
        //         radius: 70.0,
        //         backgroundColor: Colors.grey,
        //         backgroundImage: user.profileImageUrl.isEmpty
        //             ? AssetImage('assets/images/user_placeholder.jpg')
        //             : CachedNetworkImageProvider(user.profileImageUrl),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  child: Text(
                    user.bio,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 10.0),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 10.0),
                _displayButton(user),
                SizedBox(height: 30.0),
                Text(
                  'be HealEd',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontFamily: 'Comfortaa-SemiBold',
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.black,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Ganti Password',
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangePasswordScreen(
                        currentUserId: currentUserId,
                      ),
                    ),
                  ),
                  child: Text(
                    "Ganti Password",
                    style:
                        TextStyle(fontSize: 17.0, color: Colors.lightBlue[100]),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: TextButton(
                  onPressed: _logout,
                  child: Text(
                    "Log out",
                    style:
                        TextStyle(fontSize: 17.0, color: Colors.lightBlue[100]),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SlidingUpPanel(
        minHeight: 225,
        maxHeight: 375,
        panelBuilder: (scrollController) => Scaffold(
          appBar: buildAppBar(),
          body: Container(
            color: Colors.white,
            child: FutureBuilder(
              future: usersRef.document(widget.userId).get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitRing(
                      color: Colors.deepPurple,
                      size: 25.0,
                      lineWidth: 3.0,
                    ),
                  );
                }
                User user = User.fromDoc(snapshot.data);
                return ListView(
                  children: <Widget>[
                    _buildProfileInfo(user),
                  ],
                );
              },
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple,
                  Colors.lightBlueAccent,
                ]),
          ),
          child: FutureBuilder(
            future: usersRef.document(widget.userId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitRing(
                    color: Colors.white,
                    size: 25.0,
                    lineWidth: 3.0,
                  ),
                );
              }
              User user = User.fromDoc(snapshot.data);
              return ListView(
                children: <Widget>[
                  _buildProfileImage(user),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _logout() {
    AuthService.logout();
    return Navigator.pop(context);
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
