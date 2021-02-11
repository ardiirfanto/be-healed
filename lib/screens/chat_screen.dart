import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:be_healed/screens/other_profile_screen.dart';
import 'package:be_healed/services/firebase_controller.dart';
import 'package:be_healed/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:be_healed/widgets/full_image_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String receiverToken;
  final String chatId;
  final String id;
  final String currentUserId;

  Chat({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
    @required this.receiverToken,
    @required this.chatId,
    @required this.id,
    @required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: receiverAvatar.isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : CachedNetworkImageProvider(receiverAvatar),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  receiverName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherProfileScreen(
                  receiverId: receiverId,
                  userId: receiverId,
                ),
              ),
            );
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ChatScreen(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
        receiverName: receiverName,
        receiverToken: receiverToken,
        chatId: chatId,
        currentUserId: currentUserId,
        id: currentUserId,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String receiverToken;
  final String chatId;
  final String id;
  final String currentUserId;

  ChatScreen({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
    @required this.receiverToken,
    @required this.chatId,
    @required this.id,
    @required this.currentUserId,
  }) : super(key: key);

  @override
  State createState() => ChatScreenState(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
        receiverName: receiverName,
        receiverToken: receiverToken,
        chatId: chatId,
        currentUserId: currentUserId,
        id: currentUserId,
      );
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String receiverToken;
  String chatId;
  String id;
  final String currentUserId;

  ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
    @required this.receiverToken,
    @required this.chatId,
    @required this.id,
    @required this.currentUserId,
  });

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isLoading;
  int _limit = 20;
  final int _limitIncrement = 20;
  int type;

  File imageFile;
  String imageUrl;

  // String chatId;
  SharedPreferences preferences;
  // String id;
  var listMessage;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    FirebaseController.instanace.getUnreadMSGCount();

    setCurrentChatRoomID(widget.chatId);
    chatId = '';

    isLoading = false;
    imageUrl = '';

    readLocal();
  }

  @override
  void dispose() {
    setCurrentChatRoomID('none');
    super.dispose();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString("id", currentUserId);
    id = preferences.getString("id") ?? "";

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              //create list of messages
              createListMessages(),

              //Inpute Controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading() {
    return Positioned(
      child: isLoading
          ? SpinKitRing(
              color: Colors.deepPurple,
              size: 25.0,
              lineWidth: 3.0,
            )
          : Container(),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? Center(
              child: SpinKitRing(
                color: Colors.deepPurple,
                size: 25.0,
                lineWidth: 3.0,
              ),
            )
          : VisibilityDetector(
              key: Key("1"),
              onVisibilityChanged: ((visibility) {
                print('ChatRoom Visibility code is ' +
                    '${visibility.visibleFraction}');
                if (visibility.visibleFraction == 1.0) {
                  FirebaseController.instanace.getUnreadMSGCount();
                }
              }),
              child: StreamBuilder(
                stream: messagesRef
                    .document(chatId)
                    .collection(chatId)
                    .orderBy('timeStamp', descending: true)
                    .limit(_limit)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitRing(
                        color: Colors.deepPurple,
                        size: 25.0,
                        lineWidth: 3.0,
                      ),
                    );
                  } else {
                    for (var data in snapshot.data.documents) {
                      if (data['idTo'] == widget.currentUserId &&
                          data['isRead'] == false) {
                        if (data.reference != null) {
                          Firestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                            await myTransaction
                                .update(data.reference, {'isRead': true});
                          });
                        }
                      }
                    }
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          createItem(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ),
            ),
    );
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget createItem(int index, DocumentSnapshot document) {
    //right side messages
    if (document['idFrom'] == id) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 0

                    // text msg
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              document['content'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: 150.0),
                        margin: EdgeInsets.only(right: 10.0),
                      )

                    //image msg
                    : Container(
                        child: Column(
                          children: <Widget>[
                            FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.deepPurple),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      "assets/images/img_not_available.jpeg",
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullPhoto(url: document['content']),
                                  ),
                                );
                              },
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                        // margin: EdgeInsets.only(right: 10.0),
                      )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            isLastMsgRight(index)
                ? Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat("hh:mm:aa").format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timeStamp']),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          document["isRead"] == true ? 'Read' : '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    margin:
                        EdgeInsets.only(top: 5.0, bottom: 10.0, right: 10.0),
                  )
                : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
        margin: EdgeInsets.only(bottom: 5.0),
      );
    }

    //left side messages
    else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                        //display left profile image
                        // child: CachedNetworkImage(
                        //   placeholder: (context, url) => Container(
                        //     child: CircularProgressIndicator(
                        //       valueColor: AlwaysStoppedAnimation<Color>(
                        //           Colors.lightBlueAccent),
                        //     ),
                        //     width: 35.0,
                        //     height: 35.0,
                        //     padding: EdgeInsets.all(70.0),
                        //   ),
                        //   imageUrl: receiverAvatar,
                        //   width: 35.0,
                        //   height: 35.0,
                        //   fit: BoxFit.cover,
                        // ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: receiverAvatar.isEmpty
                              ? AssetImage('assets/images/user_placeholder.jpg')
                              : CachedNetworkImageProvider(receiverAvatar),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 40.0,
                      ),

                //display messages
                document['type'] == 0

                    // text msg
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: 150.0),
                        margin: EdgeInsets.only(left: 10.0),
                      )

                    //image msg
                    : Container(
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.deepPurple),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  "assets/images/img_not_available.jpeg",
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullPhoto(url: document['content']),
                              ),
                            );
                          },
                        ),
                        // margin: EdgeInsets.only(left: 10.0),
                      )
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),

            //msg time
            isLastMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat("dd MMMM, yyyy - hh:mm:aa").format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document['timeStamp']),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 10.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 5.0),
      );
    }
  }

  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getImage,
              ),
            ),
            color: Colors.white,
          ),

          //text field
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: "Write here...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          //send message icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightBlueAccent,
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
    //type=0 its text msg
    //type=1 its image

    if (contentMsg != "") {
      textEditingController.clear();

      var docRef = messagesRef
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          docRef,
          {
            "idFrom": id,
            "idTo": receiverId,
            "nameTo": receiverName,
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": contentMsg,
            "type": type,
            "isRead": false,
          },
        );
      });
      listScrollController.animateTo(
        0.0,
        duration: Duration(microseconds: 300),
        curve: Curves.easeOut,
      );
      usersRef.document(id).updateData({'chattingWith': receiverId});
      usersRef.document(receiverId).updateData({'chattingWith': id});
    } else {
      Fluttertoast.showToast(msg: "Empty Message");
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      isLoading = true;
    }
    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        storageRef.child("images/chats").child(fileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        imageUrl = downloadUrl;
        setState(
          () {
            isLoading = false;
            onSendMessage(imageUrl, 1);
          },
        );
      },
      onError: (error) {
        setState(
          () {
            isLoading = false;
          },
        );
        Fluttertoast.showToast(msg: "Error: " + error);
      },
    );
  }
}
