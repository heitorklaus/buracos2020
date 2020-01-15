import 'usuario.dart';
import 'comentario.dart';

class Post {
  int id;
  String titulo;
  String descricao;
  String img1;
  String img2;
  String img3;
  String img4;
  String img5;
  String data_hora;
  Usuario usuario;
  List<Comentario> comentario;

  Post(
      {this.id,
      this.titulo,
      this.descricao,
      this.img1,
      this.img2,
      this.img3,
      this.img4,
      this.img5,
      this.data_hora,
      this.usuario,
      this.comentario});

  Post.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.titulo = json['titulo'];
    this.descricao = json['descricao'];
    this.img1 = json['img1'];
    this.img2 = json['img2'];
    this.img3 = json['img3'];
    this.img4 = json['img4'];
    this.img5 = json['img5'];
    this.data_hora = json['data_hora'];
    this.usuario = Usuario.fromJson(json['usuario']);

    if (json['comments'] != null) {
      this.comentario = new List<Comentario>();
      json['comments'].forEach((value) {
        this.comentario.add(Comentario.fromJson(value ?? Map()));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'titulo': this.titulo,
      'descricao': this.descricao,
      'img1': this.img1,
      'img2': this.img2,
      'img3': this.img3,
      'img4': this.img4,
      'img5': this.img5,
      'usuario': this.usuario,
      'data_hora': null,
      'comentario': this.comentario != null
          ? this.comentario.map((value) => value?.toJson() ?? null).toList()
          : null
    };
  }
}
