import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String phoneNumber;
  final String age;
  final String gender;
  final String address;
  final String bio;
  final String role;
  final String chattingWith;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.phoneNumber,
    this.age,
    this.gender,
    this.address,
    this.bio,
    this.role,
    this.chattingWith,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      age: doc['age'],
      gender: doc['gender'],
      address: doc['address'],
      bio: doc['bio'] ?? '',
      role: doc['role'],
      chattingWith: null,
    );
  }
}
