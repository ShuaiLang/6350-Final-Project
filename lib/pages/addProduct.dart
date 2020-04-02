import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garage Sale"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter title of item'),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Enter price'),
            ),
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter description of the item'),
            ),
            Divider(
              height: 10,
              color: Colors.black,
              thickness: 1,
            ),
            // not figure out how to make it to the most buttom
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: () {},
                child: const Text('POST', style: TextStyle(fontSize: 16)),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
