import 'dart:ui';

import 'package:be_healed/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final DocumentSnapshot post;

  DetailScreen({this.post});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        child: BackgroundTwo(
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image.network(widget.post.data["imageUrl"]),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.post.data["title"],
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text(
                      widget.post.data["article"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      widget.post.data["article1"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      widget.post.data["article2"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      widget.post.data["article3"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      widget.post.data["article4"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
