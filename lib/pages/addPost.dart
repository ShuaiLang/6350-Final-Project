import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final6350/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class addPost extends StatefulWidget {
  @override
  _addPostState createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  String title;
  var price;
  String description;
  List<File> imageList;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final databaseReference = Firestore.instance;

    return Scaffold(
      appBar: AppBar(title: Text("Garage Sale"), centerTitle: true),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter title of item'),
              onChanged: (v) => {this.title = v},
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter price'),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9.]"))
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => {this.price = v},
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter description of the item'),
              onChanged: (v) => {this.description = v},
            ),
            Divider(
              height: 10,
              color: Colors.black,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () {
                    if (imageList == null || (imageList != null && imageList.length < 4)) {
                      pickImage();
                    } else {
                      // show snack bar or sth?
                    }
                  },
                  color: Colors.green,
                  icon: Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    if (imageList == null || (imageList != null && imageList.length < 4)) {
                      takePhoto();
                    } else {
                      // show snack bar or sth?
                    }
                  },
                  color: Colors.green,
                  icon: Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Take photo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            // show picked images
            MultiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                  return null;
                }),
            // not figure out how to make it to the most buttom
            Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.bottomRight,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('POST'),
                    onPressed: () {
                      addPost(databaseReference, this.title, this.price,
                          this.description, this.imageList);

                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Added a new post!'),
                      //   ),
                      // );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  takePhoto() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      // imageList = new List.from(imageFile);
      imageFile.add(file);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  pickImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      // imageList = new List.from(imageFile);
      imageFile.add(file);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  removeImage(int index) async {
    //imagesMap.remove(index);
    imageList.removeAt(index);
    setState(() {});
  }

  void addPost(databaseReference, title, price, description, imageList) async {
    await databaseReference.collection('post').add({
      'title': title,
      'price': price,
      'description': description,
    }).catchError((e) => {print("Got an error ${e.error}")});
  }
}

Widget MultiImagePickerList(
    {List<File> imageList, VoidCallback removeNewImage(int position)}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0
        ? Container()
        : SizedBox(
            height: 150.0,
            child: ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 3.0, right: 3.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(100),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(imageList[index]))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.red[600],
                            child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  removeNewImage(index);
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
  );
}
