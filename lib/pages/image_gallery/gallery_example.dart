import 'dart:convert';
import 'package:buracosapp/bloc/lib/models/post.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'gallery_example_item.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class GalleryExample extends StatefulWidget {
  final Post posts;

  GalleryExample({this.posts});

  @override
  _GalleryExampleState createState() => _GalleryExampleState();
}

class _GalleryExampleState extends State<GalleryExample>
    with SingleTickerProviderStateMixin {
  get posts => widget.posts;

  bool statusColor = false;

  @override
  Widget build(BuildContext context) {
    print('IMAGEM 2');
    print(widget.posts.img2);
    List galleryItems = <GalleryExampleItem>[
      GalleryExampleItem(
        id: "tag1",
        resource: posts.img1,
      )
    ];

    if (posts.img2 != null) {
      galleryItems.add(GalleryExampleItem(
        id: "tag2",
        resource: posts.img2,
      ));
    }

    if (posts.img3 != null) {
      galleryItems.add(GalleryExampleItem(
        id: "tag3",
        resource: posts.img3,
      ));
    }

    if (posts.img4 != null) {
      galleryItems.add(GalleryExampleItem(
        id: "tag4",
        resource: posts.img4,
      ));
    }

    if (posts.img5 != null) {
      galleryItems.add(GalleryExampleItem(
        id: "tag5",
        resource: posts.img5,
      ));
    }

    void open(BuildContext context, final int index) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryPhotoViewWrapper(
              galleryItems: galleryItems,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: index,
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.yellow[600],
          title: new Text(
            "BuracosApp Denúncias V1+1",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 0),
          child: buildColumn(open, context),
        ));
  }

  buildColumn(
      void open(BuildContext context, int index), BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          posts.img1 != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 90),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            open(context, 0);
                          },
                          child: Image.memory(base64Decode(posts.img1))),
                    ),
                  ],
                )
              : Center(),
          posts.img2 != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 90),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            open(context, 1);
                          },
                          child: Image.memory(base64Decode(posts.img2))

                          /*
                          * MODELO DE USO COM IMAGEM EM FADE
                          *  FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: posts.img2,
                        ),
                          * */
                          ),
                    ),
                  ],
                )
              : Center(),
          posts.img3 != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 90),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            open(context, 2);
                          },
                          child: Image.memory(base64Decode(posts.img3))),
                    ),
                  ],
                )
              : Center(),
          posts.img4 != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 90),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            open(context, 3);
                          },
                          child: Image.memory(base64Decode(posts.img4))),
                    ),
                  ],
                )
              : Center(),
          posts.img5 != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 90),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            open(context, 4);
                          },
                          child: Image.memory(base64Decode(posts.img5))),
                    ),
                  ],
                )
              : Center(),

          /* MODO DE CHAMAR ANTIGO
          *     GalleryExampleItemThumbnail(
                  galleryExampleItem: posts.img2,
                  onTap: () {
                    open(context, 2);
                  }),
          * */
        ],
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      @required this.galleryItems})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final bool cor = true;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final statusColor = false;
  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;
  bool mudarcor;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    mudarcor = widget.cor;

    if (mudarcor == true) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    }

    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mudarcor == false)
      FlutterStatusbarcolor.setStatusBarColor(Colors.yellow[600]);

    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                //itemCount: 2,
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: FlatButton(
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.yellow[600],
                    padding: EdgeInsets.all(22.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      setState(() {
                        mudarcor = false;
                      });

                      Navigator.pop(context, 1);
                    },
                    child: Text(
                      "Voltar",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  )

                  /*Text(
                  "Image ${currentIndex + 1}",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 17.0, decoration: null),
                ),*/
                  )
            ],
          )),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: MemoryImage(base64Decode(item.resource)),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroTag: item.id,
    );
  }
}
