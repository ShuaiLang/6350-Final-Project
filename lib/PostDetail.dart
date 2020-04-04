import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:final6350/Post.dart';

//class PostDetail extends StatelessWidget {
//  // Declare a field that holds the post detail.
//  final Post post;
//  final FirebaseStorage storage;
//
//  // In the constructor, require a post.
//  PostDetail({Key key, @required this.post, this.storage}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(post.title),
//      ),
//      body: ListView(
//        children: [
//          Padding(
//            padding: EdgeInsets.all(16.0),
//            child: Text(post.description),
//          ),
//
//        ],
//      ),
//    );
//  }
//}


class PostDetail extends StatelessWidget {
  final Post post;
  PostDetail({this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: ListView(
        children: [
          textSection(post: post),
          Thumbnails(images: post.images),
        ],
      ),
    );
  }
}

class Thumbnails extends StatelessWidget {
  final List images;
  Thumbnails({this.images});

  Widget imageGrid() {
    return GridView.builder(
      itemCount: images.length,
        gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder:(context, index) {
          return ImageGridItem(images[index]);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 500.0,
        child: imageGrid()
      );
  }
}

class textSection extends StatelessWidget {
  final Post post;
  textSection({this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text('Title: ${post.title}'),
          Text('Price: ${post.price}'),
          Container(
              child: new ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: new Scrollbar(
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: new Text(
                      post.description,
                    ),
                  ),
                ),
              ),
          ),
          Divider(),
        ],
      ),
    );
  }
}


class ImageGridItem extends StatefulWidget {
  String _name;
  
  ImageGridItem(String name) {
    this._name = name;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  final ref = FirebaseStorage.instance.ref();
  Uint8List imageBytes;
  String errorMsg;
  String loadingStatus = "No Image";
  getImage() {
    this.setState((){
      loadingStatus = "Loading";
    });
    ref.child(widget._name).getData(10000000).then((data) {
      this.setState((){
        imageBytes = data;
      });
    }).catchError((e) =>
        setState(() {
          errorMsg = e.toString();
        })
    );
  }

  Widget ImageWidget() {
    if (imageBytes == null) {
      return Center(child: Text(this.loadingStatus));
    } else {
      return Image.memory(imageBytes, fit: BoxFit.cover);
    }
  }

  @override
  void initState(){
    super.initState();
    getImage();
  }
  
  @override
  Widget build(BuildContext context) {
    return GridTile(child: ImageWidget());
  }
}


