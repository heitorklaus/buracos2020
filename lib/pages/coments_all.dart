import 'package:flutter/material.dart';
import 'package:buracosapp/bloc/lib/models/comentario.dart';

import 'card_comments.dart';
import 'card_comments_all.dart';

void main() => runApp(CommentsAll());

class CommentsAll extends StatefulWidget {
  CommentsAll({this.comentario});

  final List<Comentario> comentario;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CommentsAll> {
  get comentarios => widget.comentario;

  List<Widget> getComentario_all(List<Comentario> comentarios) {
    if (comentarios.length > 0) {
      return comentarios.map((comentario) {
        return CardCommentsAll(
            comment: comentario.comment,
            id: comentario.id_post.toString(),
            id_post: comentario.id_post,
            foto: comentario.usuario.foto,
            avatar: comentario.usuario.avatar,
            name: comentario.usuario.name,
            email: comentario.usuario.email);
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comentários',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.yellow[600],
          title: new Text(
            "Comentários",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: this.getComentario_all(comentarios),
          ),
        ),
      ),
    );
  }
}
