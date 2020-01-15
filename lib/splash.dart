import 'package:buracosapp/main.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: AssetImage("images/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xF0141410)),
        ),
      ),
    );
  }

  void splash(context) {
    Future.delayed(Duration(seconds: 2)).then((value) {
      print("fim de splash");
      pushReplacement(context, Lista());
    });
  }
}
