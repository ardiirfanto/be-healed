import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:be_healed/models/post_model.dart';

class PostScreen extends StatelessWidget {
  final SinglePost postData;

  const PostScreen({Key key, @required this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            'back',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Comfortaa-SemiBold',
              fontSize: 25.0,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: LayoutBuilder(
          builder: (context, _) => Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * .55,
                child: Image.network(
                  "${postData.featuredImage}",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: .65,
                  minChildSize: .65,
                  maxChildSize: .90,
                  builder: (context, controller) => Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      controller: controller,
                      children: <Widget>[
                        Text(
                          parse(("${postData.title}").toString())
                              .documentElement
                              .text,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 9),
                        Html(
                          data: "${postData.content}",
                          // showImages: true,
                          onLinkTap: (url) async {
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
