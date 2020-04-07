import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final6350/pages/Post.dart';


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
          Thumbnails(itemName: post.title, images: post.images),
        ],
      ),
    );
  }
}

class Thumbnails extends StatelessWidget {
  final String itemName;
  final List images;
  Thumbnails({this.itemName, this.images});

  Widget imageGrid() {
    return GridView.builder(
      // if no image, images here will be null
      itemCount: (images == null) ? 0 : images.length,
        gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder:(context, index) {
          return ImageGridItem(itemName, images[index], index);
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

class FullImage extends StatelessWidget {
  final Uint8List imageBytes;
  final String itemName;
  final int index;

  FullImage({this.imageBytes, this.itemName, this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${itemName} image ${index + 1}'),
      ),
      body:
          Image.memory(imageBytes, fit: BoxFit.cover),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  String _itemName;
  String _name;
  int _index;
  
  ImageGridItem(String itemName, String name, int index) {
    this._itemName = itemName;
    this._name = name;
    this._index = index;
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
    return GridTile(
        child: new InkResponse(
        enableFeedback: true,
        child: ImageWidget(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FullImage(imageBytes: imageBytes, itemName: widget._itemName, index: widget._index)),
          );
        },
      )
    );
  }
}


