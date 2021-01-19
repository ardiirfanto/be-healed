import 'dart:ui';
import 'package:be_healed/screens/detail_feed_screen.dart';
import 'package:be_healed/services/background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:be_healed/utilities/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'be HealEd',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 30.0,
          ),
        ),
      ),
      body: PostList(),
      backgroundColor: Colors.white,
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  Future _data;

  Future getPosts() async {
    QuerySnapshot qn =
        await postsRef.orderBy('createdAt', descending: true).getDocuments();

    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          post: post,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _data = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackgroundOne(
        child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitRing(
                  color: Colors.deepPurple,
                  size: 25.0,
                  lineWidth: 3.0,
                ),
              );
            } else {
              return Container(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      child: SingleChildScrollView(
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(
                                left: 7.0, right: 7.0, bottom: 20.0, top: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // SvgPicture.asset(
                                //   "assets/images/feed.svg",
                                // height: 50,
                                // ),
                                SizedBox(
                                  height: 12,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    snapshot.data[index].data["imageUrl"],
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  snapshot.data[index].data["title"],
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  snapshot.data[index].data["article"],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            // contentPadding: const EdgeInsets.all(5.0),
                            // leading: Image.network(
                            //   snapshot.data[index].data["imageUrl"],
                            //   width: 120,
                            //   fit: BoxFit.fitWidth,
                            // ),
                            // title: Text(
                            //   snapshot.data[index].data["title"],
                            //   style: TextStyle(fontSize: 20),
                            // ),
                            // subtitle: Text(
                            //   snapshot.data[index].data["firstSentence"],
                            // ),
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToDetail(snapshot.data[index]);
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
