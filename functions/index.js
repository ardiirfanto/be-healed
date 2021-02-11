const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();
const messaging = admin.messaging();

exports.onMessageCreated = functions.firestore.document(`messages/{m1}/{m2}/{m3}`).onCreate(async (snap, context) => {
    // data ini adalah data dari pesan yg dibuat
    var data = snap.data();

    // property idFrom, idTo dsb menyesuaikan struktur
    // data yg ada di collection messages
    var fromId = data.idFrom;
    var toId = data.idTo;

    // mendapatkan document terkait setiap user
    // dari collection users
    var from = await firestore.doc(`users/${fromId}`).get();
    var to = await firestore.doc(`users/${toId}`).get();

    // mendapatkan data dari document yg sudah didapatkan
    var toData = to.data();

    // mendapatkan token firebase
    // cek di flutter, pada lib/services/firebase_messaging_services.dart
    // pada method _sendTokenToServer, ada perintah untuk mengupdate
    // value firebase_token untuk setiap user
    var token = toData.firebase_token;
    if (token !== null) {
        return messaging.send({
            token: token,
            data: {
                'data': JSON.stringify(data),
            },
            notification: {
                // title: from.name,
                title: `New message`,
                body: data.content,
                badge: '1',
                sound: 'default'
            }
        });
    }

    return null;
});