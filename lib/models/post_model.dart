import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String imageUrl;
  String title;
  String author;
  String article;
  Timestamp createdAt;

  // Post({
  //   this.id,
  //   this.imageUrl,
  //   this.title,
  //   this.article,
  //   this.timestamp,
  // });

  Post.fromMap(Map<String, dynamic> data) {
    id = data[id];
    imageUrl = data['imageUrl'];
    title = data['title'];
    author = data['author'];
    article = data['article'];
    createdAt = data['createdAt'];
  }
}
