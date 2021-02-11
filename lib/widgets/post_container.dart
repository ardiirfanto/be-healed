import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class PostContainer extends StatelessWidget {
  final onTap;
  final String title, image, excerpt;

  const PostContainer(
      {Key key, this.onTap, this.title, this.image, this.excerpt})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: GestureDetector(
        onTap: onTap,
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
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: Image.network(
                      "$image",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Text(
                    parse(("$title").toString()).documentElement.text,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Text(
                    parse(("$excerpt").toString()).documentElement.text,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
