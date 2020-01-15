import 'dart:convert';
import 'dart:io';

import 'package:buracosapp/pages/utils/alerts.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/prefs.dart';
import '../response.dart';
import '../user_save_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../utils/api.dart';

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final api = Api();

  Future loginGoogle(context) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Usuario do Firebase
      final result = await _auth.signInWithCredential(credential);
      final FirebaseUser fuser = result.user;
      // Passo a configuração que o usuario vai receber, Privilegios
      final Object obj = ["user", "pm"];

      // SE LOGAR NO FIREBASE, CRIO UM CADASTRO NOVO NO BANCO
      final user = User(fuser.displayName, fuser.email, fuser.email,
          fuser.photoUrl, fuser.uid, obj, null);
      // chamo a classe User e salvo as preferencias acima, o numero 1 é um DEFAULT depois que receber um id do cadastraFirebase() eu trato embaixo

      // Executo o metodo de cadastro
      cadastraFirebase(user, context).then((resposta) {
        print('Resposta do cadastro ' + resposta.toString());
      });
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();

      print(error.toString());
    }

    // Resposta genéricarr
    //return Response(true, "Login efetuado com sucesso", 200);
  }

  Future crianoBuracos(h, b) async {
    final vres = await http
        .post(api.getUrl() + 'auth/signup', headers: h, body: b)
        .then((resultado) {
      return resultado;
    }).catchError((onError) {
      return onError;
    });

    return vres;
  }

  Future logaNoBuracosFromBuracos(h, b, context) async {
    final result = await http
        //.post('http://192.168.15.41:8090/api/auth/signin', headers: h, body: b)
        .post(api.getUrl() + 'auth/signin', headers: h, body: b)
        .then((resultado) {
      final data = json.decode(resultado.body);

      final map = {"token": data["accessToken"]};
      Prefs.setString("user.token", json.encode(map));

      // Salvando na memoria SHARED PREFERENCES o usuario
      final map_user = {
        "name": data["name"],
        "email": data["email"],
        "avatar": data["avatar"]
      };

      print('Resultado da requisicao');
      if (resultado.statusCode == 200) {
        Prefs.setString("user.prefs", json.encode(map_user));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        var status = resultado.statusCode;
        alert(context, 'Erro $status',
            'Ops, Ocorreu um erro! \nConfirme seus dados e tente novamente!');
      }

      return resultado;
    }).catchError((onError) {
      return onError;
    });

    return result.statusCode;
  }

  void updateToken() {
    if (_auth.currentUser() != null) {
      _auth.currentUser().then((val) {
        val.getIdToken().then((onValue) {
          print(onValue.token);
          // here you can mutate state to BLoC or Provider
          // or Inherited widget
          // for example - authBloc.passFirebaseToken.add(onValue.token);
        });
      });
    }
  }

  Future logaNoBuracos(h, b) async {
    final result = await http
        //.post('http://192.168.15.41:8090/api/auth/signin', headers: h, body: b)
        .post(api.getUrl() + 'auth/signin', headers: h, body: b)
        .then((resultado) {
      final data = json.decode(resultado.body);

      final map = {"token": data["accessToken"]};
      Prefs.setString("user.token", json.encode(map));

      return resultado;
    }).catchError((onError) {
      return onError;
    });

    return result.statusCode;
  }

  Future cadastraFirebase(User user, context) async {
    final url = api.getUrl() + "auth/signup";
    print("> post: $url");

    final headers = {"Content-Type": "application/json"};
    final body = convert.json.encode(user.toMap());

    final resposta =
        await http.post(url, headers: headers, body: body).then((value) {
      //#TODO: Melhorar o sistema de login e cadastro do usuario do FIREBASE
      // Estou separando porque no futuro preciso melhorar isso

      // Se deu erro 400 indicando que ja é cadastrado, tenta fazer login...
      if (value.statusCode == 400) {
        logaNoBuracos(headers, body).then((onValue) async {
          print('Resposta do login');
          print(onValue);

          // Caso login é invalido
          if (onValue != 200) {
            Navigator.of(context, rootNavigator: true).pop();

            alert(context, 'Erro',
                'Ops, Você já tem um cadastro com este email, utilize o nosso Login para acessar!');

            final GoogleSignIn _googleSignIn = GoogleSignIn();
            final FirebaseAuth _auth = FirebaseAuth.instance;

            await _googleSignIn.disconnect();
            await _auth.signOut().then((onValue) {
              // pushReplacement(context, Lista());
            });
          } else {
            // se fez login
            user.save();
            Navigator.of(context, rootNavigator: true).pop();
            pushReplacement(context, Lista());
          }
        });
        return value.statusCode;
      }

      // Se teve sucesso no cadastro depois de ter logado no firebase, faz o cadastro no BURACOS
      if (value.statusCode == 200) {
        user.save();
        logaNoBuracos(headers, body).then((onValue) {
          Navigator.of(context, rootNavigator: true).pop();
          pushReplacement(context, Lista());
        });
      }
      print('resultado do cadastro');
      print(value.body);
      print(value.statusCode);
    });

    return resposta;
    //.timeout(Duration(seconds: 10), onTimeout: _onTimeOut);

    // final r = Response.fromJson(convert.json.decode(s));

    // print(r);

    //final r = Response.fromJson(convert.json.decode(s));

    //  print('RETORNO');
    //print(r);SxHU1xMMNjccIsQlbjoYcL7o8Ef2
  }

  static FutureOr<http.Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
