class Usuario {
  final int id;
  String name;
  String email;
  String foto;
  String avatar;

  Usuario(this.id, this.name, this.email, this.foto, this.avatar);

  Usuario.fromJson(Map<String, dynamic> jsonUser)
      : id = jsonUser['id'],
        name = jsonUser['name'],
        email = jsonUser['email'],
        foto = jsonUser['foto'],
        avatar = jsonUser['avatar'];

  @override
  String toString() {
    return "Usuario[$id]: $id, name: $name, email: $email, foto: $foto, avatar: $avatar";
  }
}
