import 'dart:convert';
import 'dart:io';

import 'package:buracosapp/bloc/lib/models/post.dart';
import 'package:buracosapp/domain/ImageUpload.dart';
import 'package:buracosapp/domain/images_storage.dart';
import 'package:buracosapp/domain/user_save_prefs.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:buracosapp/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../../main.dart';
import '../utils/alert_wait.dart';
import 'image_picker_handler.dart';
import 'package:buracosapp/domain/services/posts_service.dart';

class CameraModule extends StatefulWidget {
  CameraModule({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CameraModuleState createState() => new _CameraModuleState();

  static void userImage(File croppedFile) {}
}

class _CameraModuleState extends State<CameraModule>
    with
        TickerProviderStateMixin,
        ImagePickerListener,
        AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = true;
  final _tDescricao = TextEditingController();

  File _image1;
  File _image2;
  File _image3;
  File _image4;

  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  logo() {
    return Container(
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0,
        child: Image.asset('images/logoApp.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.yellow[600],
      body: FutureBuilder<User>(
          future: User.get(),
          builder: (context, snapshot3) {
            return snapshot3.hasData
                ? _body(context)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                              ' Você precisa se logar para enviar uma denúncia!')),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: new MaterialButton(
                          height: 70.0,
                          minWidth: 355.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.black,
                          child: new Text('Ir para tela de login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23)),
                          onPressed: () {
                            Lista().getterTab();
                          },
                          splashColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  void oferecerDenuncia(context) async {
    final descricao = _tDescricao.text;

    if (!_formKey.currentState.validate()) {
      return;
    }

    // Resgato os valores do SHARED
    await Prefs.getString("images.storage").then((result) {
      final images = ImagesStorage.fromJson(json.decode(result));

      // Quando resgatar monto o objeto de envio

      var now = new DateTime.now();

      final data = "${now.day}-${now.month}-${now.year}";

      final posts = Post();
      posts.titulo = "BuracosApp 1.0";
      posts.data_hora = data.toString();
      posts.descricao = descricao.toString();
      posts.img1 = images.image1;
      posts.img2 = images.image2;
      posts.img3 = images.image3;
      posts.img4 = images.image4;

// circular
      setState(() {
        WaitAlert().alert(context);
      });
      //enviaPost(context, posts);
      PostsService.setPosts(context, posts).then((onValue) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    });
  }

  Future enviaPost(context, Post posts) async {
    await PostsService.setPosts(context, posts).then((r) {
      if (r.isOk()) {
        setState(() {
          pushReplacement(context, Lista());
        });
      }
    });
  }

  String _validateDenuncia(String text) {
    if (text.isEmpty) {
      return "não pode estar em branco!";
    }
    return null;
  }

  _body(context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: logo(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: _validateDenuncia,
                    controller: _tDescricao,
                    style: TextStyle(fontSize: 26),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "Faça sua denuncia!",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18)),
                  ),
                ),
              ],
            )),
          ),

          // IMAGEM 1

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Imagem 1
                      Container(
                        child: new GestureDetector(
                          onTap: () {
                            final map = {"nome": "image1"};
                            Prefs.setString("imageSet", json.encode(map));
                            imagePicker.showDialog(context);
                          },
                          child: new Center(
                            child: _image1 == null
                                ? new Stack(
                                    children: <Widget>[
                                      new Center(
                                        child: new CircleAvatar(
                                            child: new Icon(
                                              OMIcons.cameraAlt,
                                              size: 40,
                                            ),
                                            radius: 40.0,
                                            backgroundColor: Colors.black45
                                            //const Color(0xFF778899),
                                            ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    _image1,
                                    width: 80,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Imagem 2
                      Visibility(
                        visible: _image1 != null,
                        child: new GestureDetector(
                          onTap: () {
                            final map = {"nome": "image2"};
                            Prefs.setString("imageSet", json.encode(map));
                            imagePicker.showDialog(context);
                          },
                          child: new Center(
                            child: _image2 == null
                                ? new Stack(
                                    children: <Widget>[
                                      new Center(
                                        child: new CircleAvatar(
                                            child: new Icon(
                                              OMIcons.cameraAlt,
                                              size: 40,
                                            ),
                                            radius: 40.0,
                                            backgroundColor: Colors.black45
                                            //const Color(0xFF778899),
                                            ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    _image2,
                                    width: 80,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Imagem 3
                      Visibility(
                        visible: _image2 != null,
                        child: new GestureDetector(
                          onTap: () {
                            final map = {"nome": "image3"};
                            Prefs.setString("imageSet", json.encode(map));
                            imagePicker.showDialog(context);
                          },
                          child: new Center(
                            child: _image3 == null
                                ? new Stack(
                                    children: <Widget>[
                                      new Center(
                                        child: new CircleAvatar(
                                            child: new Icon(
                                              OMIcons.cameraAlt,
                                              size: 40,
                                            ),
                                            radius: 40.0,
                                            backgroundColor: Colors.black45
                                            //const Color(0xFF778899),
                                            ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    _image3,
                                    width: 80,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Imagem 4
                      Visibility(
                        visible: _image3 != null,
                        child: new GestureDetector(
                          onTap: () {
                            final map = {"nome": "image4"};
                            Prefs.setString("imageSet", json.encode(map));
                            imagePicker.showDialog(context);
                          },
                          child: new Center(
                            child: _image4 == null
                                ? new Stack(
                                    children: <Widget>[
                                      new Center(
                                        child: new CircleAvatar(
                                            child: new Icon(
                                              OMIcons.cameraAlt,
                                              size: 40,
                                            ),
                                            radius: 40.0,
                                            backgroundColor: Colors.black45
                                            //const Color(0xFF778899),
                                            ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    _image4,
                                    width: 80,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: _progress
                            ? Visibility(
                                visible: _progress,
                                child: Center(
                                  child: new MaterialButton(
                                    height: 70.0,
                                    minWidth: 40.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(70.0)),
                                    color: Color(0xF0141410),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Text('Enviar Denúncia',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23)),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      oferecerDenuncia(context);
                                    },
                                    splashColor: Colors.redAccent,
                                  ),
                                ),
                              )
                            : CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xF0141410)),
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  userImage(File _image) async {
    String s = await Prefs.getString("imageSet");

    print("IMAGEM" + s);
    final image = ImageUpload.fromJson(json.decode(s));

    print('imagem ' + image.nome);
    if (image.nome == 'image1') {
      setState(() {
        this._image1 = _image;
      });
    }
    if (image.nome == 'image2') {
      setState(() {
        this._image2 = _image;
      });
    }
    if (image.nome == 'image3') {
      setState(() {
        this._image3 = _image;
      });
    }
    if (image.nome == 'image4') {
      setState(() {
        this._image4 = _image;
      });
    }
  }
}
