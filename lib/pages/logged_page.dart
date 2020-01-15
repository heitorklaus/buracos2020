import 'package:flutter/material.dart';

import '../domain/user_save_prefs.dart';

import '../pages/utils/nav.dart';

import '../main.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage>
    with AutomaticKeepAliveClientMixin<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[600],
        body: Padding(
          padding: EdgeInsets.all(22),
          child: _body(context),
        ));
  }

  _body(context) {
    return Form(
      child: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: logo(),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: new MaterialButton(
                height: 70.0,
                minWidth: 70.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.black,
                child: new Text('Sair do App',
                    style: TextStyle(color: Colors.white, fontSize: 23)),
                onPressed: () {
                  User.clear(context);
                  pushReplacement(context, Lista());
                },
                splashColor: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('images/logoApp.png'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
