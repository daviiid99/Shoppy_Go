import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'note.dart';
import 'create.dart';

class Categoria extends StatefulWidget{
  @override
  Map<dynamic, dynamic> products = {};
  String miCategoria = "";

  Categoria(miCategoria, products){
    this.miCategoria = miCategoria;
    this.products = products;
  }
  _CategoriaState createState() => _CategoriaState(this.miCategoria, this.products);
}

class _CategoriaState extends State<Categoria>{

  Map<dynamic, dynamic> products = {};
  String miCategoria = "";

  _CategoriaState(miCategoria, products){
    this.miCategoria = miCategoria;
    this.products = products;
  }

  List<String> misProductos = [];
  List<String> misFotos = [];

  updateProductLists() async {
    for (String key in products[miCategoria].keys){
      setState(() async {
        if (misProductos.contains(key) == false){
          misProductos.add(key);
          misFotos.add(products[miCategoria][key]);
        }
      });
    }
  }

  @override
  void initState(){
    setState(() async {
      await updateProductLists();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(miCategoria, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
      Expanded(
      child : ListView.builder(
      itemCount: misProductos.length ,
          itemBuilder: (context, index) {
            return StatefulBuilder(
                builder: (context, setState) {
                  return Card(
                      color: Colors.transparent,
                      child: ListTile(
                        tileColor: Colors.transparent,
                        textColor: Colors.black,
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipOval(
                                child: Image.asset(misFotos[index]),
                              )
                          ),
                        ),
                        title: Text(misProductos[index], style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),
                        onTap: (){
                        },

                      ));
                }
            );
          }
      )
    ),
    ]
    )
    );
  }
}