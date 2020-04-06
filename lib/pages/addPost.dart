import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final6350/model.dart';
import 'package:validators/validators.dart' as validator;


class addPost extends StatefulWidget {
  @override
  _addPostState createState() => _addPostState();
}
class _addPostState extends State<addPost> {
  final _formKey = GlobalKey<FormState>();
  Model model = Model();
  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('New post'),
        ),
        body:
        Form(
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
                isDescription: true,
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
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    Navigator.pop(context, '${model.title} added!');
                  }
                },
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
        ),
        validator: validator,
        onSaved: onSaved,
        keyboardType: isDescription ? TextInputType.multiline : TextInputType.text,
        maxLines: isDescription ? null : 1,
      ),
    );
  }
}