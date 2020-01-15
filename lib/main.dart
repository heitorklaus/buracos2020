import 'dart:async';

import 'package:buracosapp/pages/camera_module/camera.dart';
import 'package:buracosapp/pages/coments_all.dart';
import 'package:buracosapp/pages/logged_page.dart';
import 'package:buracosapp/pages/login_page.dart';
import 'package:buracosapp/splash.dart';
import 'package:buracosapp/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
// NAVEGACAO
import 'package:buracosapp/pages/utils/nav.dart';

// IMPORT DO PACKAGE LISTPOST BLOC
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buracosapp/bloc/lib/models/models.dart';
import 'package:buracosapp/bloc/lib/bloc/bloc.dart';

import 'bloc/lib/models/comentario.dart';
import 'domain/services/posts_service.dart';
import 'domain/user_save_prefs.dart';
import 'pages/card_comments.dart';

import 'dart:convert';

// Galeria
import 'package:buracosapp/pages/image_gallery/gallery_example.dart';

void main() async {
  // ISSO É DO BLOC POSTS pasta libPosts
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp());
}

void _onClickPost(BuildContext context, p) {
  print(999);
  push(
      context,
      (GalleryExample(
        posts: p,
      )));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with AutomaticKeepAliveClientMixin<MyApp> {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.yellow[600]);
    FlutterStatusbarcolor.setNavigationBarColor(const Color(0xFFcdcddf));
    bool showComments = false;

    final appTitle = 'Buracos App';
    return MaterialApp(
        title: appTitle, home: SplashPage(), debugShowCheckedModeBanner: false);
  }
}
/* 
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // Home Page Contem as ABAS c
    return HomePage();
  }
} */

// LoadPosts
// #TODO
// OS WIDGETS ESTÃO NA MAIN, DEPOIS REFATORAR

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();

  getterTab() {
    _ListaState.toggleTab();
  }
}

class _ListaState extends State<Lista> with SingleTickerProviderStateMixin {
  static int tabIndex = 0;
  static TabController tabController;

  // icons Change
  int isPressed;

  @override
  void _setActiveTabIndex() {
    print(tabController.indexIsChanging);

    isPressed = tabController.index;
  }

  void initState() {
    super.initState();

    // Controle de quantidade de TABS
    tabController = TabController(vsync: this, length: 5);

    /**/
    tabController.addListener(_setActiveTabIndex);
    if (tabIndex == 0) bottomButtonHome = 'Início';
  }

  @override
  _onClickLoginGoogle() async {
    String s = await Prefs.getString("user.prefs");
    if (s == null || s.isEmpty) {
      print("vazio");
    } else {
      final user = User.fromJson(json.decode(s));
      print(user.nome);
      return user.nome;
    }
  }

  // Metodo para jogar a tab para login
  static toggleTab() {
    print('111');
    tabIndex = 4; //tabController.index + 1;
    tabController.animateTo(tabIndex);
  }

  String bottomButtonHome;
  String bottomButtonDoubt;
  String bottomButtonCamera;
  String bottomButtonFone;
  String bottomButtonUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
            backgroundColor: Colors.yellow[600],
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  BlocProvider(
                    builder: (context) =>
                        PostBloc(httpClient: http.Client())..dispatch(Fetch()),
                    child: ListPost(),
                  ),
                  new Text("teste"),
                  CameraModule(),
                  new Text("teste"),
                  FutureBuilder<User>(
                      future: User.get(),
                      builder: (context, snapshot) {
                        //#TODO JOGAR ISSO PRO BACKEND

                        return snapshot.hasData == true
                            ? UserPage()
                            : LoginPage();
                      }),
                ]),
            bottomNavigationBar: menuBottom()),
      ),
    );
  }

  menuBottom() {
    return BottomNavigationBar(
      backgroundColor: Colors.black38,
      type: BottomNavigationBarType.fixed,
      key: Key(''),
      currentIndex: tabIndex,
      onTap: (_tabIndex) {
        setState(() {
          tabIndex = _tabIndex;

          if (_tabIndex == 0) {
            bottomButtonHome = 'Home';
            bottomButtonDoubt = null;
            bottomButtonCamera = null;
            bottomButtonFone = null;
            bottomButtonUser = null;
          }

          if (_tabIndex == 1) {
            bottomButtonHome = null;
            bottomButtonDoubt = 'Dúvidas';
            bottomButtonCamera = null;
            bottomButtonFone = null;
            bottomButtonUser = null;
          }

          if (_tabIndex == 2) {
            bottomButtonHome = null;
            bottomButtonDoubt = null;
            bottomButtonCamera = ' ';
            bottomButtonFone = null;
            bottomButtonUser = null;
          }

          if (_tabIndex == 3) {
            bottomButtonHome = null;
            bottomButtonDoubt = null;
            bottomButtonCamera = null;
            bottomButtonFone = 'Fones';
            bottomButtonUser = null;
          }

          if (_tabIndex == 4) {
            bottomButtonHome = null;
            bottomButtonDoubt = null;
            bottomButtonCamera = null;
            bottomButtonFone = null;
            bottomButtonUser = 'Login';
          }
        });

        tabController.animateTo(_tabIndex);
      },
      items: [
        _buildNavigationItem(
            bottomButtonHome, 'home2.svg', 'home.svg', 24, tabIndex),
        _buildNavigationItem(
            bottomButtonDoubt, 'doubt3.svg', 'doubt.svg', 24, tabIndex),
        _buildNavigationItem(
            bottomButtonCamera, 'photo.svg', 'camera.svg', 28, tabIndex),
        _buildNavigationItem(
            bottomButtonFone, 'phone22.svg', 'telephone.svg', 24, tabIndex),
        _buildNavigationItem2(
            bottomButtonUser, 'user4.svg', 'user.svg', 24, tabIndex)
      ],
    );
  }
}

BottomNavigationBarItem _buildNavigationItem(String title, String image,
    String disabledImage, double size, int _tabIndex) {
  return BottomNavigationBarItem(
    title: title == null
        ? SizedBox(
            height: 0,
          )
        : Column(
            children: <Widget>[
              SizedBox(
                height: 0,
              ),
              Container()
            ],
          ),
    icon: title == null
        ? SvgPicture.asset('images/$disabledImage',
            width: size, color: Colors.white)
        : SvgPicture.asset('images/$image', width: 24, color: Colors.white),
  );
}

BottomNavigationBarItem _buildNavigationItem2(String title, String image,
    String disabledImage, double size, int _tabIndex) {
  return BottomNavigationBarItem(
    title: SizedBox(
      height: 0,
    ),
    icon: Tab(
      child: FutureBuilder<User>(
        future: User.get(),
        builder: (BuildContext context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.foto != null
                  ? Container(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.foto),
                        radius: 18,
                        child: const Text(''),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.yellow[600],
                      ),
                      padding: const EdgeInsets.all(2.0), // borde width
                      decoration: new BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Colors.yellow[700]), // border color
                        shape: BoxShape.circle,
                      ))
                  : Container(
                      child: ClipOval(
                          child: new Image.memory(
                        base64Decode(snapshot.data.avatar),
                        width: 45,
                        height: 65,
                        fit: BoxFit.cover,
                        matchTextDirection: true,
                      )),
                      padding: const EdgeInsets.all(2.0), // borde width
                      decoration: new BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Colors.yellow[700]), // border color
                        shape: BoxShape.circle,
                      ))
              : title == null
                  ? SvgPicture.asset('images/$disabledImage',
                      width: size, color: Colors.white)
                  : SvgPicture.asset('images/$image',
                      width: 24, color: Colors.white);
        },
      ),
    ),
  );
}

class ListPost extends StatefulWidget {
  @override
  _ListPostState createState() => _ListPostState();
}

bool show = false;
bool show2 = true;

@override
class _ListPostState extends State<ListPost>
    with AutomaticKeepAliveClientMixin<ListPost> {
  bool get wantKeepAlive => true;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  Widget buildLoading() => Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xF0141410)),
      ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostError) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: Text('Falha em Carregar os Posts!'),
              ),
              new RawMaterialButton(
                onPressed: () {
                  pushReplacement(context, Lista());
                },
                child: new Icon(
                  Icons.refresh,
                  color: Color(0xF0141410),
                  size: 35.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.yellow,
                padding: const EdgeInsets.all(15.0),
              ),
            ],
          ));
        }

        if (state is RefreshState) {
          return buildLoading();
        }

        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(
              child: Text('Nenhum Post Encontrado!'),
            );
          }

          return RefreshIndicator(
            backgroundColor: Colors.yellow,
            color: Colors.black54,
            onRefresh: _refresh,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print(index);

                //final p = state.posts[index];

                return index >= state.posts.length
                    ? BottomLoader()
                    : PostWidget(post: state.posts[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: _scrollController,
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xF0141410)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.dispatch(Fetch());
    }
  }

  Future<Null> _refresh() async {
    _postBloc.dispatch(PostRefresh());
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 44,
          height: 44,
          child: Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  List<CardComments> _montaListaComentarios = List<CardComments>();
  final comentarioController = TextEditingController();
  int idPost;
  int c = 0;

  List<Widget> getComentario_all(List<Comentario> comentarios) {
    if (comentarios.length > 0) {
      /*if (comentarios.length > 1) {
        comentarios.length = 2;
      } */
      return comentarios.map((comentario) {
        return CardComments(
            comment: comentario.comment,
            id: comentario.id_post.toString(),
            id_post: comentario.id_post,
            foto: comentario.usuario.foto,
            avatar: comentario.usuario.avatar,
            name: comentario.usuario.name,
            email: comentario.usuario.email);
      }).toList();
    } else {
      return [];
    }
  }

  bool showComments = false;
  bool sentComment = false;

  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.all(1),
      child: Center(
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  widget.post.img1 != null
                      ? InkWell(
                          onTap: () {
                            final p = Post(
                                id: widget.post.id,
                                titulo: widget.post.titulo,
                                descricao: widget.post.descricao,
                                img1: widget.post.img1,
                                img2: widget.post.img2,
                                img3: widget.post.img3,
                                img4: widget.post.img4,
                                img5: widget.post.img5);

                            // print('Comentarios');
                            //print(widget.post.comentario.first.comment);

                            _onClickPost(context, p);

                            //print(Post(id:post.id,titulo: post.titulo, descricao: post.descricao, img1: post.img1));
                          },
                          child: Image.memory(base64Decode(widget.post.img1)))
                      : Stack(
                          children: <Widget>[
                            // Max Size

                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ),

                            Image.network(
                                "https://cdn.consumidormoderno.com.br/wp-content/uploads/2016/03/4ab18c9add5061df687957d52d72b4ce_XL.jpg"),
                          ],
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, top: 8.0, right: 10, bottom: 10),
                        child: Container(
                            child: widget.post.usuario.foto != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.post.usuario.foto),
                                    radius: 20,
                                    child: const Text(''),
                                    backgroundColor: Colors.yellow[600],
                                    foregroundColor: Colors.yellow[600],
                                  )
                                : ClipOval(
                                    child: new Image.memory(
                                    base64Decode(widget.post.usuario.avatar),
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    matchTextDirection: true,
                                  )),
                            padding: const EdgeInsets.all(2.0), // borde width
                            decoration: new BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black26), // border color
                              shape: BoxShape.circle,
                            )),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              widget.post.usuario.name
                                          .trim()
                                          .split(" ")
                                          .length ==
                                      2
                                  ? Row(
                                      children: <Widget>[
                                        Text(
                                            widget.post.usuario.name
                                                .trim()
                                                .split(" ")[0],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(" "),
                                        Text(
                                            widget.post.usuario.name
                                                .trim()
                                                .split(" ")[1],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  : Text(
                                      widget.post.usuario.name
                                          .trim()
                                          .split(" ")[0],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4, left: 4, right: 10),
                    child: Column(
                      children: <Widget>[
                        new Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: new Text(
                                widget.post.data_hora,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[],
              ),
              Column(
                children: <Widget>[
                  new Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 2.0, left: 4, right: 4),
                        child: new Text(
                          widget.post.descricao,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      )),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        child: this
                                    .getComentario_all(widget.post.comentario)
                                    .length >
                                0
                            ? this.getComentario_all(widget.post.comentario)[0]
                            : Center(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: FlatButton(
                            child: widget.post.comentario.length > 0
                                ? Text(
                                    'Ver (' +
                                        widget.post.comentario.length
                                            .toString() +
                                        ') comentários',
                                    style: TextStyle(color: Colors.black38),
                                  )
                                : Container(),
                            onPressed: () {
                              //  push(context, CommentsAll());

                              push(
                                  context,
                                  (CommentsAll(
                                      comentario: widget.post.comentario)));
                            },
                          ),
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      child: FutureBuilder<User>(
                          future: User.get(),
                          builder: (context, snapshot) {
                            //#TODO JOGAR ISSO PRO BACKEND

                            return snapshot.hasData == false
                                ? Container()
                                /*
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                        textColor: Colors.black,
                                        padding: new EdgeInsets.all(30.0),
                                        child: new Text(
                                          "Clique aqui para logar e comentar",
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          Lista().getterTab();
                                        },
                                      )
                                    ],
                                  )
                                */
                                : Container(
                                    padding: EdgeInsets.only(
                                        top: 8, left: 2, right: 2),
                                    child: TextFormField(
                                      maxLength: 255,
                                      controller: comentarioController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFfbfbff),

                                        suffixIcon: !sentComment
                                            ? IconButton(
                                                onPressed: () {
                                                  if (comentarioController
                                                          .text.length >
                                                      0) {
                                                    setState(() {
                                                      sentComment =
                                                          !sentComment;
                                                    });
                                                    {
                                                      final comentario =
                                                          Comentario();

                                                      comentario.comment =
                                                          comentarioController
                                                              .text;
                                                      comentario.id_post =
                                                          widget.post.id;

                                                      PostsService.setComment(
                                                          context, comentario);
                                                    }
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.send,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.black),
                                                  ),
                                                )),

                                        // Estado normal
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18.0)),
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: Color(0xFFf1f1f6),
                                              width: 1.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 2.0),
                                        ),

                                        hintText: "Comente essa publicacao...",
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 30.0, 20.0),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
