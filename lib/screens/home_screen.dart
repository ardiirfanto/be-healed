import 'dart:ui';
import 'package:be_healed/screens/chat_list_screen.dart';
import 'package:be_healed/screens/feed_screen.dart';
import 'package:be_healed/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:be_healed/models/user_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          ChatListScreen(
            currentUserId: currentUserId,
          ),
          ProfileScreen(
            currentUserId: currentUserId,
            userId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.lightBlueAccent,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sms_rounded,
              size: 30.0,
            ),
            title: Text(
              'Chat',
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
