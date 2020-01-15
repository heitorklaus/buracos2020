import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:buracosapp/domain/firebase/firebase-service.dart';
import 'package:buracosapp/pages/utils/alerts.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:buracosapp/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/lib/models/post.dart';
import '../../bloc/lib/models/comentario.dart';
import '../../bloc/lib/bloc/post_bloc.dart';
import '../../bloc/lib/bloc/post_event.dart';

import 'package:buracosapp/utils/prefs.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../response.dart';
import '../token.dart';
import '../user_save_prefs.dart';

class PostsService {
  static retornaToken() async {
    String s = await Prefs.getString("user.token");

    if (s == null || s.isEmpty) {
      print("vazio");
    } else {
      final token = Token.fromJson(json.decode(s));

      return token.token;
    }
  }

  static Future setComment(context, Comentario comentario) async {
    var api = Api();
    final body = convert.json.encode(comentario.toJson());
    final token = await retornaToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    await http
        .post(api.getUrl() + "comments/", body: body, headers: headers)
        .then((value) async {
      final valor = value.body;

      final r = Response.fromJson(convert.json.decode(valor));
      print(value.statusCode);

      if (value.statusCode != 200) {
        print(
            'Usuario com token expirado, comentario nao realizado... fazendo login...');
        await User.get().then((f) {
          if (f.password != null) {
            var body = json.encode({
              "username": f.email,
              "email": f.email,
              "password": f.password
            });

            Map<String, String> header2s = {
              'Content-type': 'application/json',
              'Accept': 'application/json',
            };

            FirebaseService().logaNoBuracos(header2s, body).then((f) async {
              print('status logado com sucesso, nova tentativa de comentario');
              Map<String, String> headers2 = {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              };

              final comentNovo = convert.json.encode(comentario.toJson());
              await http
                  .post(api.getUrl() + "comments/",
                      body: comentNovo, headers: headers2)
                  .then((f) {
                print('comentario realizado na segunda tentativa');

                //limpando cache de imagens
                Prefs.setString("images.storage", "");

                pushReplacement(context, Lista());
                return r;
              });
            }).catchError((onError) {
              print(onError);
              alert(
                  context,
                  'Buracos App',
                  'Comentário não realizado, Erro desconhecido \n' +
                      onError.toString());
            });
          }
        });
      } else {
        print('Comentario realizado na primeira tentativa');
        PostBloc _postBloc;
        _postBloc = BlocProvider.of<PostBloc>(context);

        _postBloc.dispatch(PostRefresh());

        print(value.body);
      }
    });
  }

// Executo a funcao de cadastrar posts
  static Future setPosts(context, Post post) async {
    var api = Api();

    final body = convert.json.encode(post.toJson());

    final token = await retornaToken();

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response =
        await http.post(api.getUrl() + "posts/", body: body, headers: headers);

    final s = response.body;

    print('Tenta enviar o post...');
    print("RESULTADO DO POST < $s");

    final r = Response.fromJson(convert.json.decode(s));

    if (r.status == 401) {
      print(
          'Usuario com token expirado, post nao cadastrado... fazendo login...');
      await User.get().then((f) {
        if (f.password != null) {
          var body = json.encode(
              {"username": f.email, "email": f.email, "password": f.password});

          Map<String, String> header2s = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          };

          FirebaseService().logaNoBuracos(header2s, body).then((f) async {
            print('status logado com sucesso, nova tentativa de post');
            Map<String, String> headers2 = {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            };

            final postNovo = convert.json.encode(post.toJson());
            await http
                .post(api.getUrl() + "posts/",
                    body: postNovo, headers: headers2)
                .then((f) {
              print('post realizado na segunda tentativa');

              //limpando cache de imagens
              Prefs.setString("images.storage", "");

              pushReplacement(context, Lista());
              return r;
            });
          }).catchError((onError) {
            print(onError);
            alert(
                context,
                'Buracos App',
                'Post não realizado, Erro desconhecido \n' +
                    onError.toString());
          });
        }
      });
    } else {
      Prefs.setString("images.storage", "");

      print('Usuario com token em dia, post cadastrado na primeira tentativa!');
      print(200);
      pushReplacement(context, Lista());
      return r;
    }
  }
}
