import 'dart:convert';
import 'dart:ui';
import 'package:be_healed/models/post_model.dart';
import 'package:be_healed/screens/post_screen.dart';
import 'package:be_healed/widgets/overlayed_container.dart';
import 'package:be_healed/widgets/post_container.dart';
import 'package:be_healed/widgets/shimmer_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:be_healed/services/wp_api.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  FeedScreen({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _FeedScreenState createState() => _FeedScreenState(
        currentUserId: currentUserId,
      );
}

class _FeedScreenState extends State<FeedScreen> {
  final String currentUserId;
  _FeedScreenState({@required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "be HealEd",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 25.0,
            fontFamily: 'Comfortaa-SemiBold',
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

List<SinglePost> parsePosts(response) {
  final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
  return parsed.map<SinglePost>((json) => SinglePost.fromJson(json)).toList();
}

Future<List<SinglePost>> _getPosts() async {
  final response = await http.get(baseUrl);
  return compute(parsePosts, response.body);
}

class _PostListState extends State<PostList> {
  Future<List<SinglePost>> _postsFuture;
  final double appBarHeight = 30;
  @override
  void initState() {
    super.initState();
    _postsFuture = _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<SinglePost>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          if (snapshot.hasData) {
            return Scaffold(
              body: SlidingUpPanel(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                minHeight: MediaQuery.of(context).size.height * .42,
                maxHeight: MediaQuery.of(context).size.height * .75,
                panelBuilder: (scrollController) => Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Scaffold(
                    appBar: buildAppBar(),
                    body: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "Artikel Terbaru Kisara.or.id",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        toolbarHeight: 15,
                      ),
                      body: ListView.separated(
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => PostContainer(
                          image: "${snapshot.data[i].featuredImage}",
                          title: "${snapshot.data[i].title}",
                          excerpt: "${snapshot.data[i].excerpt}",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostScreen(postData: snapshot.data[i]),
                            ),
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                      ),
                    ),
                  ),
                ),
                body: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .35,
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      child: PageView.builder(
                        controller: PageController(viewportFraction: .76),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, i) => OverlayedContainer(
                          image: "${snapshot.data[i].featuredImage}",
                          title: "${snapshot.data[i].title}",
                          excerpt: "${snapshot.data[i].excerpt}",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostScreen(postData: snapshot.data[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: SlidingUpPanel(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                minHeight: MediaQuery.of(context).size.height * .43,
                maxHeight: MediaQuery.of(context).size.height * .75,
                panelBuilder: (scrollController) => Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Scaffold(
                    appBar: buildAppBar(),
                    body: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "Artikel Terbaru Kisara.or.id",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        toolbarHeight: 15,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(9),
                        child: ListView.separated(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, i) => Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Colors.grey[300],
                            child: ShimmerPostContainer(),
                          ),
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                body: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .35,
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      child: PageView.builder(
                        controller: PageController(viewportFraction: .76),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, i) => Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: ShimmerOverlayedContainer(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            // return Scaffold(
            //   body: Center(
            //     child: SpinKitRing(
            //       color: Colors.deepPurple,
            //       size: 25.0,
            //       lineWidth: 3.0,
            //     ),
            //   ),
            // );
          }
        },
      ),
    );
  }

  Widget buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Center(
          child: Container(
            height: 8.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      );
}
