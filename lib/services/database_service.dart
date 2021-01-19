import 'package:be_healed/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:be_healed/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'id': user.id,
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'age': user.age,
      'gender': user.gender,
      'address': user.address,
      'role': user.role,
      'chattingWith': user.chattingWith,
    });
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }
}
