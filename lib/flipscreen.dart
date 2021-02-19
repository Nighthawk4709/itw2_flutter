import 'package:flutter/material.dart';
import 'dart:math';
import 'package:itw_take_home_ass/main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
        actions: [
          FlatButton.icon(
              onPressed: () {
                currentTheme.switchTheme();
              },
              icon: Icon(Icons.brightness_1_sharp),
              label: Text("Switch Theme")),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(
            //ROW 1
            children: [
              getContainer(),
              getContainer(),
            ],
          ),
          Row(//ROW 2
              children: [
            getContainer(),
            getContainer(),
          ]),
        ]),
      ),
    );
  }
}

Widget getContainer() {
  return Container(
    child: Text("Hey"),
    height: 200,
    width: 200,
    //color: Colors.blue,
    margin: EdgeInsets.all(25.0),
    color: Colors.blue,
  );
}
