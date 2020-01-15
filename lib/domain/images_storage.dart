class ImagesStorage {
  String image1;
  String image2;
  String image3;
  String image4;
  String image5;

  ImagesStorage(
      this.image1, this.image2, this.image3, this.image4, this.image5);

  ImagesStorage.fromJson(Map<String, dynamic> jsonUser)
      : image1 = jsonUser['image1'],
        image2 = jsonUser['image2'],
        image3 = jsonUser['image3'],
        image4 = jsonUser['image4'],
        image5 = jsonUser['image5'];

  @override
  String toString() {
    return "image1: $image1, image2: $image2, image3: $image3, image4: $image4, image5: $image5";
  }
}
