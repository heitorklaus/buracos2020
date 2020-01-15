import 'usuario.dart';

class Comentario {
  int id;
  int id_post;
  String comment;
  Usuario usuario;

  Comentario({this.id, this.id_post, this.comment, this.usuario});

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_post = json['id_post'];
    comment = json['comment'];
    usuario = Usuario.fromJson(json['usuario']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();

    json['id_post'] = this.id_post;
    json['comment'] = this.comment;

    return json;
  }
}
