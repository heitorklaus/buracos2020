import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class CardComments extends StatelessWidget {
  String id;

  int id_post;

  String comment;
  String foto;
  String name;
  String email;
  String avatar;

  CardComments(
      {this.id,
      this.id_post,
      this.comment,
      this.foto,
      this.name,
      this.email,
      this.avatar});

  createFileFromString(img) async {
    final encodedStr = img;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/abc.png';
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print('teste');
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Divider(thickness: 1, color: Color(0xFFF5F5F5)),
          Flexible(
            child: RichText(
              textAlign: TextAlign.justify,
              text: new TextSpan(
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: this.name + " ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: this.comment),
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }
}
