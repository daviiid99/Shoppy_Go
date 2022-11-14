import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoppy_go/Categoria.dart';
import 'dart:convert';
import 'dart:io';
import 'note.dart';
import 'create.dart';

class Glosario extends StatefulWidget{
  @override
  Map<dynamic, dynamic> products = {};
  Glosario(products) {
    this.products = products;
  }
  _GlosarioState createState() => _GlosarioState(this.products);
}

class _GlosarioState extends State<Glosario>{

  Map<dynamic, dynamic> products = {};

  _GlosarioState(products){
    this.products = products;
  }

  String jsonFile = "products.json";
  String jsonString = "";
  Map<dynamic, dynamic> myNotes = {};
  List<String> categorias = [];
  List<int> categoriaIndex = [];
  List<String> categoriaImages = [];

  Future<String> get _LocalFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _LocalFile async {
    final path = await _LocalFilePath;
    return File("$path/$jsonFile");
  }

  updateCategories() {
    // Add all categories to list

    for (String key in products.keys){
      if (categorias.contains(key) == false ){
        setState(() async {
          categorias.add(key);
        });

      }
    }
  }

  indexCategories(){
    int count = 0;
    int index = -1;
    for (String key in products.keys){
      index ++;
      count = 0;
      for (String subKey in products[key].keys){
        categoriaImages.add(index.toString());
        categoriaImages[index] = products[key][subKey];
        count ++;
        setState(() async {
          categoriaIndex.add(index);
          categoriaIndex[index] = count;
        });
      }
    }
  }


  @override
  void initState(){
    setState(() async {
      await updateCategories();
      indexCategories();
      print(products);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Glosario de productos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
      Expanded(
          child : ListView.builder(
          itemCount: categorias.length ,
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
                                    child: Image.file(File(categoriaImages[index])),
                                  )
                              ),
                            ),
                            title: Text(categorias[index], style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                            subtitle: Text(categoriaIndex[index].toString() + " productos", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                            onTap: (){
                              Navigator.push(
                                  context,
                              MaterialPageRoute(builder: (context) => Categoria(categorias[index], products) ));
                            },

                          ));
                    }
                );
              }
          )
      ),
        ],

      ),
    );
  }
}