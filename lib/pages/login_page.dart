import 'dart:convert';

import 'package:buracosapp/domain/firebase/firebase-service.dart';
import 'package:buracosapp/domain/user_avatar.dart';

import 'package:buracosapp/pages/utils/alert_wait.dart';
import 'package:buracosapp/pages/utils/nav.dart';
import 'package:buracosapp/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../main.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'utils/alerts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

enum FormType { login, register }

class _LoginPage extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  bool get wantKeepAlive => true;
  var _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    setState(() {
      _image = image;
    });

    final map = {
      "avatar": base64Image,
    };
    Prefs.setString("user.avatar", json.encode(map));
    print(base64Image);
    return map;
  }

  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _tCSenha = TextEditingController();
  final _tNome = TextEditingController();
  bool block = false;
  final GlobalKey<FormState> _formCreate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  int _formType = 1;

  var _progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[600],
        body: Padding(
          padding: EdgeInsets.all(22),
          child: _body(context),
        ));
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Informe o nome";
    }
    return null;
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Informe o e-mail";
    }
    return null;
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Informe um e-mail válido!';
    else
      return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Informe a Senha";
    }
    return null;
  }

  String _validateCSenha(String text) {
    if (text != _tSenha.text) {
      return "As senhas nao conferem!";
    }
    return null;
  }

  _body(context) {
    return ListView(
      children: <Widget>[
        Column(
          children: createForm(),
        )
      ],
    );
  }

  List<Widget> createForm() {
    if (_formType == 1) {
      return [
        Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: logo(),
          ),
        ),
        Container(
          child: Form(
            key: _formLogin,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new TextFormField(
                    controller: _tLogin,
                    validator: _validateEmail,
                    decoration: new InputDecoration(
                      labelText: "Digite seu e-mail",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    controller: _tSenha,
                    validator: _validateSenha,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "Digite sua senha",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new FlatButton(
          textColor: Colors.black,
          padding: new EdgeInsets.all(30.0),
          child: new Text(
            "Não é cadastrado? Crie uma conta!",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          onPressed: moveToRegister,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: new MaterialButton(
              height: 63.0,
              minWidth: 355.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              color: Colors.black,
              child: new Text('Login',
                  style: TextStyle(color: Colors.white, fontSize: 23)),
              onPressed: () {
                _onClickLogin(context);
              },
              splashColor: Colors.redAccent,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: !_progress
              ? ButtonTheme(
                  minWidth: 355,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FlatButton.icon(
                      color: Colors.black,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      icon: new SvgPicture.asset(
                        'images/search.svg',
                        width: 40,
                      ),
                      //`Icon` to display
                      label: Padding(
                        padding: const EdgeInsets.all(19.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: new Text(
                            'Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _onClickLoginGoogle(context);
                      }),
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
        ),

        /*
          * InputDecoration(
              // Quando o input for clicado
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: "Digite seu  email",
              fillColor: Colors.red,
              // Estado normal
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              ),

              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
            ),
          *
          * */

        /* input com backgound
          *  Padding(
              padding: const EdgeInsets.only(top: 20),
              child: new Material(
                borderRadius: new BorderRadius.circular(25.0),
                color: const Color(0xFF141415),
                child: new TextFormField(
                  decoration: new InputDecoration(
                  //  labelText: "Teste",
                    hintText: "Digite seu e-mail:",
                    hintStyle: TextStyle(fontSize: 17,color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ))
          *
          * */
      ];
    }

    if (_formType == 2) {
      return [
        Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: logo(),
          ),
        ),
        Container(
          child: Form(
            key: _formCreate,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _tNome,
                    validator: _validateNome,
                    maxLength: 30,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      labelText: "Digite seu nome",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _tLogin,
                    validator: _validateEmail,
                    maxLength: 80,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      labelText: "Digite seu e-mail",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    controller: _tSenha,
                    maxLength: 50,
                    validator: _validateSenha,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "Digite sua senha",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: _tCSenha,
                    maxLength: 50,
                    validator: _validateCSenha,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "Confirme sua senha",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _image == null
                    ? InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Center(
                          child: new CircleAvatar(
                              child: new Icon(
                                OMIcons.cameraAlt,
                                size: 60,
                              ),
                              radius: 60.0,
                              backgroundColor: Colors.black45
                              //const Color(0xFF778899),
                              ),
                        ),
                      )
                    : InkWell(
                        onTap: () => getImage(),
                        child: ClipOval(
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                            matchTextDirection: true,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: new MaterialButton(
                      height: 63.0,
                      minWidth: 355.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      color: Colors.black,
                      child: new Text('Criar uma conta',
                          style: TextStyle(color: Colors.white, fontSize: 23)),
                      onPressed: () {
                        _onClickCreate(context);
                      },
                      splashColor: Colors.redAccent,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: new FlatButton(
                    textColor: Colors.black,
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      "Voltar para o Login!",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onPressed: moveToLogin,
                  ),
                )
              ],
            ),
          ),
        ),
      ];
    }
  }

  logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 40.0,
        child: Image.asset('images/logoApp.png'),
      ),
    );
  }

  _onClickLoginGoogle(context) async {
    WaitAlert().alert(context);

    final service = FirebaseService();
    service.loginGoogle(context);

    /*
if (response.isOk()) {
      print('ok');
      Navigator.of(context, rootNavigator: true).pop();
      pushReplacement(context, Lista());
    } else {
      print('nao ok');
    }
    */
  }

  void moveToRegister() {
    setState(() {
      _tLogin.text = "";
      _tSenha.text = "";

      //  _formType = FormType.register;
      _formType = 2;
    });
  }

  void moveToLogin() {
    //_formKey.currentState.reset();

    _tLogin.text = "";
    _tSenha.text = "";
    _tCSenha.text = "";

    setState(() {
      _formType = 1;
    });
  }

  Future<void> asyncAleasyncAlertsrtDialog(
      BuildContext context, title, message) async {
    String returnVal = await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context, 'sucess');
                })
          ],
        );
      },
    );
    if (returnVal == 'sucess') {
      setState(() {
        print(returnVal);
      });
    }
  }

  void _onClickCreate(BuildContext context) async {
    if (!_formCreate.currentState.validate()) {
    } else {
      setState(() {
        WaitAlert().alert(context);
      });

      await Prefs.getString("user.avatar").then((imageSet) {
        final path = UserAvatar.fromJson(json.decode(imageSet));

        final login = _tLogin.text;
        final senha = _tSenha.text;
        final nome = _tNome.text;
        final foto = path.avatar;

        final image = _image;
        List<int> imageBytes = image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);

        Map<String, String> header2s = {'Content-type': 'application/json'};
        final Object obj = ["user", "pm"];
        var body = json.encode({
          "name": nome,
          "username": login,
          "email": login,
          "password": senha,
          "role": obj,
          "avatar": base64Image,
        });

        print(body);
        FirebaseService().crianoBuracos(header2s, body).then((f) async {
          print(f);
          if (f.statusCode == 200) {
            pushReplacement(context, Lista());
            Navigator.of(context, rootNavigator: true).pop();
          } else {
            Navigator.of(context, rootNavigator: true).pop();

            print(f.body);
            alert(context, 'Buracos App', f.body);
            //final data = json.decode(f.body);
            // asyncAleasyncAlertsrtDialog(context, "Buracos App", f.body);
          }
        });
      });
    }
  }

  void _onClickLogin(BuildContext context) async {
    if (!_formLogin.currentState.validate()) {
    } else {
      WaitAlert().alert(context);
      final login = _tLogin.text;
      final senha = _tSenha.text;

      Map<String, String> header2s = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      var body =
          json.encode({"username": login, "email": login, "password": senha});
      print(body);

      FirebaseService()
          .logaNoBuracosFromBuracos(header2s, body, context)
          .then((f) async {
        //  f = 300;
        if (f == 200) {
          push(context, Lista());
          Navigator.of(context, rootNavigator: true).pop();
        } else {}
      }).catchError((onError) {
        //   alert(context, 'Erro', 'Ops! Ocorreu um erro!');
      });
    }
  }

/*
   @override
  bool get wantKeepAlive => true;

 */
}
