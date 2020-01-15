
import 'dart:convert';

import '../utils/prefs.dart';


class Token {

  final String token;


  Token(this.token);

  Token.fromJson(Map<String, dynamic> map)
      :
        this.token = map["token"];

  Map toMap() {
    Map<String,dynamic> map = {
      "token": token
    };

    return map;
  }


  @override
  String toString() {
    return "token: $token";
  }

}