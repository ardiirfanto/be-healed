import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService with ChangeNotifier {
  StreamSubscription<String> _tokenSubscription;
  FirebaseMessagingService() {
    _initialize();
  }

  _initialize() async {
    final messaging = FirebaseMessaging();
    final permitted = await messaging.requestNotificationPermissions();
    if (permitted ?? true) {
      final token = await messaging.getToken();
      await _sendTokenToServer(token);

      _tokenSubscription = messaging.onTokenRefresh.listen((newToken) {
        _sendTokenToServer(newToken);
      });

      // notification handling
      messaging.configure(
        onMessage: (data) async {
          // ini akan dieksekusi ketika ada pesan baru yg diterima
          // dan aplikasi dalam keadaan dibuka (foreground)
          // firebase tidak menampilkan notifikasi jika aplikasi dalam keadaan dibuka
          // jadi, jika ingin tetap menampilkan notifikasi
          // tampilkan notifikasi tersebut menggunakan flutter_local_notification
        },
        onLaunch: (data) async {
          // ini akan dieksekusi ketika user mengklik notifikasi
          // dan posisi aplikasi dalam keadaan closed
          //
          // handling notifikasi bisa dilakukan disini
          // misalnya jika notifikasi diklik maka masuk ke page tertentu
        },
        onResume: (data) async {
          // ini akan dieksekusi ketika user mengklik notifikasi
          // dan posisi aplikasi dalam keadaan closed
          //
          // handling notifikasi bisa dilakukan disini
          // misalnya jika notifikasi diklik maka masuk ke page tertentu
        },
      );
    }
  }

  _sendTokenToServer(String token) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final firestore = Firestore.instance;
    final userDoc = firestore.document('users/${currentUser.uid}');

    // token ini akan digunakan oleh firebase function
    // ketika akan mengirim notifikasi ke user saat ini
    // lihat file /functions/index.js
    await userDoc.updateData({
      'firebase_token': token,
    });
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    super.dispose();
  }
}
