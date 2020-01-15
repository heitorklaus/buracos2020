import 'package:buracosapp/main.dart';
import 'package:buracosapp/pages/utils/alerts.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:flutter/material.dart';

class WaitAlert extends StatefulWidget {
  WaitAlert({Key key, this.content, this.context}) : super(key: key);

  final Widget content;
  final dynamic context;

  _WaitAlertState createState() => _WaitAlertState();

  void alert(BuildContext context) {
    _WaitAlertState().alerta(context);
  }
}

class _WaitAlertState extends State<WaitAlert> {
  bool value = false;
  @override
  void initState() {
    super.initState();
  }

  alerta(context) {
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Buracos App'),
            content: FlatButton(
              child: CircularProgressIndicator(),
            ),
            actions: <Widget>[],
          );
        });
  }
}
