import 'package:buracosapp/main.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String title, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      });
}
