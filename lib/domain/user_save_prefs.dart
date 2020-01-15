import 'dart:convert';

import 'package:buracosapp/pages/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../utils/prefs.dart';

class User {
  final String nome;
  final String usuario;
  final String email;
  final String foto;
  final String password;
  final Object roles;
  final String avatar;

  User(this.nome, this.usuario, this.email, this.foto, this.password,
      this.roles, this.avatar);

  User.fromJson(Map<String, dynamic> map)
      : this.nome = map["nome"],
        this.usuario = map["usuario"],
        this.email = map["email"],
        this.foto = map["foto"],
        this.password = map["password"],
        this.roles = map["roles"],
        this.avatar = map["avatar"];

  void save() {
    // Salvando na memoria SHARED PREFERENCES o usuario
    final map = {
      "name": nome,
      "username": usuario,
      "email": usuario,
      "foto": foto,
      "password": password,
      "role": roles,
      "avatar": avatar
    };
    print(map);
    Prefs.setString("user.prefs", json.encode(map));
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "name": nome,
      "username": usuario,
      "email": usuario,
      "password": password,
      "role": roles,
      "foto": foto,
      "avatar": avatar
    };

    return map;
  }

  static Future<User> get() async {
    String s = await Prefs.getString("user.prefs");
    if (s == null || s.isEmpty) {
      return null;
    }

    final user = User.fromJson(json.decode(s));

    return user;
  }

  static Future clear(context) async {
    Prefs.setString("user.prefs", "");
    Prefs.setString("user.token", "");
    Prefs.setString("images.storage", "");
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    await _googleSignIn.disconnect();
    await _auth.signOut().then((onValue) {
      // pushReplacement(context, Lista());
    });
    print('Limpou Token e Preferencias');

    return true;
  }
}
