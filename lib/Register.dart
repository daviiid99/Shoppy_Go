import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Register extends StatefulWidget {
  @override
  Map<dynamic,dynamic> productos = {};
  Register(productos){
    this.productos = productos;
  }
  _RegisterState createState() => _RegisterState(this.productos);
}

class _RegisterState extends State<Register> {

  Map<dynamic, dynamic> productos = {};
  String currentCategory = "";
  List<String> categories = [];
  final noteName = TextEditingController();
  String jsonFile = "products.json";
  String jsonString = "";

  _RegisterState(productos) {
    this.productos = productos;
  }

  Future<String> get _LocalFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _LocalFile async {
    final path = await _LocalFilePath;
    return File("$path/$jsonFile");
  }

  updateCategoriesList() async {
    // We'll iterate between existing categories
    for (String category in productos.keys) {
      if (categories.contains(category) == false) {
        setState(() async {
          categories.add(category);
        });

      }
    }
  }

  addProductToMap (String product) async {
    // Await for file
    final file = await _LocalFile;

    // Add new keys to map
    productos[currentCategory][product] = "assets/icon/icon.png";
    print(productos[currentCategory][product]);

    // Encode json file
    jsonString = jsonEncode(productos);
    file.writeAsString(jsonString);
  }

  chooseNoteName() async {

    showDialog(
        context: context,
        builder: (context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    backgroundColor: Colors.transparent,
                    content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Nombre del producto\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
                            TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  border: OutlineInputBorder(
                                  ),
                                  labelText: ""), cursorColor: Colors.white,
                              controller: noteName,
                            ),

                            TextButton(
                              child: Text("Guardar"),
                              onPressed: ()  async{
                                setState(() async {
                                  await addProductToMap(noteName.text.toLowerCase());
                                  var index = 2;
                                  while (index > 0){
                                    index -=1;
                                    Navigator.pop(context);
                                  }
                                });

                              },
                            )

                          ],
                        )
                    )
                );
              }
          );
        }
    );
  }


  @override
  void initState() {
    setState(() async{
      updateCategoriesList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Selecciona una categoria", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
        ),
        body: Column(
            children: [
              Expanded(
              child : ListView.builder(
                itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return StatefulBuilder(
                        builder: (context, setState) {
                          return Card(
                            color: Colors.transparent,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              textColor: Colors.black,
                              title: Text(
                                categories[index], textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                              onTap: () {
                                setState((){
                                  currentCategory = categories[index];
                                  chooseNoteName();
                                });


                              },
                            ),
                          );
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