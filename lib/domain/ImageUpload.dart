class ImageUpload {
  String nome;

  ImageUpload(
    this.nome,
  );

  ImageUpload.fromJson(Map<String, dynamic> jsonUser) : nome = jsonUser['nome'];

  @override
  String toString() {
    return "$nome";
  }
}
