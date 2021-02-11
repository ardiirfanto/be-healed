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

class SinglePost {
  final String featuredImage, title, date, content, excerpt;

  SinglePost(
      {this.content, this.featuredImage, this.title, this.date, this.excerpt});

  factory SinglePost.fromJson(Map<String, dynamic> json) {
    return SinglePost(
      content: json['content']['rendered'],
      date: json['date'],
      featuredImage: json['_embedded']['wp:featuredmedia'][0]['source_url'],
      title: json['title']['rendered'],
      excerpt: json['excerpt']['rendered'],
    );
  }
}
