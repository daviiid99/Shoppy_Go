import 'package:flutter/material.dart';
import 'home.dart';

// Where the magic begins :)
void main() => runApp(ShoppyGo());


class ShoppyGo extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Shoppy Go",
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Home(),
    );
  }
}
