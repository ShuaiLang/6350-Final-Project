import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final6350/model.dart';
import 'package:validators/validators.dart' as validator;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class addPost extends StatefulWidget {
  @override
  _addPostState createState() => _addPostState();
}
class _addPostState extends State<addPost> {
  final _formKey = GlobalKey<FormState>();
  Model model = Model();
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('New post'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: MyTextFormField(
                      hintText: 'Title',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter your item title';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        model.title = value;
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: MyTextFormField(
                      hintText: 'Price',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter your item price';
                        }
                        if (!validator.isNumeric(value)) {
                          return 'Enter a validate price';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        model.price = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            MyTextFormField(
              hintText: 'description',
//              isDescription: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (String value) {
                model.description = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () {
                    if (model.imageList == null ||
                        (model.imageList != null && model.imageList.length < 4)) {
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
                    if (model.imageList == null ||
                        (model.imageList != null && model.imageList.length < 4)) {
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
              imageList: model.imageList,
              removeNewImage: (index) {
                removeImage(index);
                return null;
              }),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  await postInfo(databaseReference, model.title, model.price,
                      model.description, model.imageList);
                  Navigator.pop(context, '${model.title} added!');
                }
              },
              child: Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // not figure out how to make it to the most buttom
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
      if (model.imageList == null) {
        model.imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          model.imageList.add(file);
        }
      }
//      setState(() {});
    }
  }

  pickImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      // imageList = new List.from(imageFile);
      imageFile.add(file);
      if (model.imageList == null) {
        model.imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          model.imageList.add(file);
        }
      }
//      setState(() {});
    }
  }

  removeImage(int index) async {
    //imagesMap.remove(index);
    model.imageList.removeAt(index);
//    setState(() {});
  }

  void postInfo(databaseReference, title, price, description, imageList) async {
    // post image successful then post other info
    List<String> randomFileNames = [];

    for (var image in imageList) {
      // var completePath = image.path;
      // var fileName = (completePath.split('/').last);
      // print(completePath + ' ' +fileName);

      // generate a random file name
      String fileName = UniqueKey().toString() + '.jpg';
      randomFileNames.add(fileName);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }

    await databaseReference.collection('post').add({
      'title': title,
      'price': price,
      'description': description,
      'images': randomFileNames,
    });
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

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isDescription;
  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isDescription= false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.grey[200],
          filled: true,
          border: InputBorder.none,
        ),
        validator: validator,
        onSaved: onSaved,
        keyboardType: isDescription ? TextInputType.multiline : TextInputType.text,
        maxLines: isDescription ? null : 1,
      ),
    );
  }
}