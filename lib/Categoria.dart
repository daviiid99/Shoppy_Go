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
  String jsonString = "";

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

  writeJson() async {
    jsonString = jsonEncode(products);
    File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/products.json").writeAsString(jsonString);
  }

  removeCategory() async {
    setState(() async {
      products.remove(miCategoria);
      writeJson();
    });
  }

  removeProductFromList(String product, int indice) async {
      setState(() async {
        misProductos.remove(misProductos[indice]);
        misFotos.remove(misFotos[indice]);
        products[miCategoria].remove(product);
        writeJson();
      });
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
                                child: Image.file(File(misFotos[index])),
                              )
                          ),
                        ),
                        title: Text(misProductos[index], style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),
                        onTap: (){
                        },
                        trailing: Wrap(

                          children : [
                            IconButton(
                                onPressed: (){
                                  removeProductFromList(misProductos[index], index);
                                },
                                icon: Icon(Icons.remove_circle, color: Colors.red,)),
                          ],

                        ),

                      ));
                }
            );
          }
      )
    ),
    ]
    ),

        bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          removeCategory();
          int index = 2 ;
          while(index > 0){
            Navigator.pop(context);
            index -=1;
          }

          },
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              label: "",
              backgroundColor: Colors.transparent,
              icon: IconButton(
                icon:  Icon(Icons.delete_rounded, color: Colors.white,),
                onPressed: () {
                  removeCategory();
                  int index = 2 ;
                  while(index > 0){
                    Navigator.pop(context);
                    index -=1;
                  }


                },
              )
            )
          ],
    ),
    );
  }
}