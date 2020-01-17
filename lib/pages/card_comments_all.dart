import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class CardCommentsAll extends StatelessWidget {
  String id;

  int id_post;

  String comment;
  String foto;
  String name;
  String email;
  String avatar;

  CardCommentsAll(
      {this.id,
      this.id_post,
      this.comment,
      this.foto,
      this.name,
      this.email,
      this.avatar});

  createFileFromString(img) async {
    final encodedStr = img;
    var now = new DateTime.now();

    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var valor = md5.convert(utf8.encode(now.toString())).toString();
    String fullPath = '$dir/$valor.png';
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print('teste' + valor);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Divider(thickness: 1, color: Color(0xFFF5F5F5)),
        Stack(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Container(
                        child: this.foto != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(this.foto),
                                radius: 23,
                                child: const Text(''),
                                backgroundColor: Colors.yellow[600],
                                foregroundColor: Colors.yellow[600],
                              )
                            : ClipOval(
                                child: FutureBuilder(
                                  future: createFileFromString(this.avatar),
                                  builder: (ctx, snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          backgroundColor: Colors.yellow,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      );

                                    return Center(
                                      child: Image.file(
                                        snapshot.data,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                        matchTextDirection: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                        padding: const EdgeInsets.all(2.0), // borde width
                        decoration: new BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.yellow[700]), // border color
                          shape: BoxShape.circle,
                        )),
                    padding: const EdgeInsets.all(1.0), // borde width
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 60),
              child: Text(
                this.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16, left: 60),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      this.comment,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(thickness: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}
