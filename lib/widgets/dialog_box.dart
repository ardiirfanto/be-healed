import 'package:flutter/material.dart';

class DialogBox {
  information(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Email atau Password yang anda masukkan salah'),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  return Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
