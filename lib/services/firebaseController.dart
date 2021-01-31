import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  static FirebaseController get instanace => FirebaseController();

  Future<int> getUnreadMSGCount([String receiverId]) async {
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      receiverId == null
          ? targetID = (prefs.get('userId') ?? 'NoId')
          : targetID = receiverId;
//      if (targetID != 'NoId') {
      final QuerySnapshot chatListResult = await Firestore.instance
          .collection('users')
          .document(targetID)
          .collection('chatlist')
          .getDocuments();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.documents;
      for (var data in chatListDocuments) {
        final QuerySnapshot unReadMSGDocument = await Firestore.instance
            .collection('messages')
            .document(data['chatId'])
            .collection(data['chatId'])
            .where('idTo', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .getDocuments();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.documents;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }
      print('unread MSG count is $unReadMSGCount');
//      }
      if (receiverId == null) {
        FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      } else {
        return unReadMSGCount;
      }
    } catch (e) {
      print(e.message);
    }
  }
}
