import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buracosapp/domain/ImageUpload.dart';
import 'package:buracosapp/domain/images_storage.dart';
import 'package:buracosapp/domain/response.dart';
import 'package:buracosapp/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'image_picker_dialog.dart';
import 'image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  static File imagedouble;

  ImagePickerHandler(this._listener, this._controller);

  static openCamera2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage2(image);
  }

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.8,
      ratioY: 1.4,
      statusBarColor: Colors.yellow,
      toolbarTitle: "Editar imagem...",
      toolbarColor: Colors.yellow,
      maxWidth: 512,
      maxHeight: 512,
    );
    await upload64(croppedFile);
    _listener.userImage(croppedFile);

    print('chama cropped file');
  }

  static cropImage2(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.8,
      ratioY: 1.4,
      statusBarColor: Colors.yellow,
      toolbarTitle: "Editar imagem...",
      toolbarColor: Colors.yellow,
      maxWidth: 512,
      maxHeight: 512,
    );

    userImage2(croppedFile);

    print('chama cropped file');
    upload64(croppedFile);
  }

  static Future<Response> upload64(File file) async {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    // Abro o IMAGESET onde eu sei qual SLOT de imagem esta sendo processado
    await Prefs.getString("imageSet").then((imageSet) {
      final image = ImageUpload.fromJson(json.decode(imageSet));

      // Passo como parametro para o methodo
      imagesInSlot(image, base64Image);
    });

    //String fileName = path.basename(file.path);
    //var body = {"fileName": fileName, "base64": base64Image};
    //print("http.upload >> " + body.toString());
  }

  static Future imagesInSlot(image, base64Image) async {
    await Prefs.getString("images.storage").then((imageResult) {
      var images_storage = ImagesStorage.fromJson(json.decode(imageResult));

      var imagem1 = images_storage.image1;
      var imagem2 = images_storage.image2;
      var imagem3 = images_storage.image3;
      var imagem4 = images_storage.image4;
      var imagem5 = images_storage.image5;

      String i = image.toString();

      if (i == 'image1') {
        print('IMAGEM 1 TA 0 e vai ser atualizada');
        final map = {
          "image1": base64Image,
          "image2": imagem2,
          "image3": imagem3,
          "image4": imagem4,
          "image5": imagem5
        };
        Prefs.setString("images.storage", json.encode(map));
      }
      if (i == 'image2') {
        print('IMAGEM 2 TA 0 e vai ser atualizado');
        final map = {
          "image1": imagem1,
          "image2": base64Image,
          "image3": imagem3,
          "image4": imagem4,
          "image5": imagem5
        };
        Prefs.setString("images.storage", json.encode(map));
      }
      if (i == 'image3') {
        print('IMAGEM 3 TA 0 e vai ser atualizado');
        final map = {
          "image1": imagem1,
          "image2": imagem2,
          "image3": base64Image,
          "image4": imagem4,
          "image5": imagem5
        };
        Prefs.setString("images.storage", json.encode(map));
      }
      if (i == 'image4') {
        print('IMAGEM 4 TA 0 e vai ser atualizado');
        final map = {
          "image1": imagem1,
          "image2": imagem2,
          "image3": imagem3,
          "image4": base64Image,
          "image5": imagem5
        };
        Prefs.setString("images.storage", json.encode(map));
      }
      if (i == 'image5') {
        print('IMAGEM 5 TA 0 e vai ser atualizado');
        final map = {
          "image1": imagem1,
          "image2": imagem2,
          "image3": imagem3,
          "image4": imagem4,
          "image5": base64Image
        };
        Prefs.setString("images.storage", json.encode(map));
      }
    });
  }

  showDialog(BuildContext context) async {
    await Prefs.getString("images.storage").then((imageResult) {
      if (imageResult == null || imageResult.isEmpty) {
        print('CRIOU O OBJETO IMAGESTORE UNICA VEZ');
        final map = {
          "image1": null,
          "image2": null,
          "image3": null,
          "image4": null,
          "image5": null
        };
        Prefs.setString("images.storage", json.encode(map));
      }
    });

    imagePicker.getImage(context);
  }

  static userImage2(File _image) async {
    String s = await Prefs.getString("imageSet");
    print("IMAGEM" + s);
    final image = ImageUpload.fromJson(json.decode(s));

    print('imagem ' + image.nome);

    imagedouble = _image;
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
