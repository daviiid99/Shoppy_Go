import 'dart:convert';

import 'package:flutter/material.dart';
import 'notebook.dart';
import 'dart:io';

class Note extends StatefulWidget{
  @override

  String myNote = "";
  Map<dynamic, dynamic> myNotes = {};
  Map<dynamic, dynamic> products = {};


  Note(String myNote, Map<dynamic, dynamic> myNotes, Map<dynamic, dynamic> products){
    this.myNote = myNote;
    this.myNotes = myNotes;
    this.products = products;
  }

  _NoteState createState() => _NoteState(this.myNote, this.myNotes, this.products);
}

class _NoteState extends State<Note>{

  String myNote = "";
  String jsonString = "";
  Map<dynamic, dynamic> myNotes = {};
  Map<dynamic, dynamic> products = {};
  List<String> currentProducts = [];
  List<int> currentAmounts = [];
  List<String>  currentImages = [];

  _NoteState(String myNote, Map<dynamic, dynamic> myNotes, Map<dynamic, dynamic> products){
    this.myNote = myNote;
    this.myNotes = myNotes;
    this.products = products;
  }

  decodeCurrentNote(){
    // Assign current note to a list of elements

    for(String nota in myNotes.keys){
      if (nota.contains(myNote)){
        for(String producto in myNotes[nota].keys){
          setState(() async {
            currentProducts.add(producto);
            currentAmounts.add(myNotes[nota][producto][1]);
            currentImages.add(myNotes[nota][producto][0]);
          });

        }
      }
    }
  }

  removeProductFromList(String product, int indice, int amount) async {
    // We'll delete the choosed product or decrease his amount!
    if (amount == 1){
      // We wont to remove it from list
      setState(() async {
        currentProducts.remove(product);
        currentAmounts.remove(currentAmounts[indice]);
        currentImages.remove(currentImages[indice]);
      });
    } else {
      setState(() async {
        currentAmounts[indice]  -=1 ;
      });
    }
  }

  removeHere() async {
    myNotes.remove(myNote);

    // Get json file source
    final file = await File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/myNotes.json");

    // Encode json
    jsonString = jsonEncode(myNotes);
    file.writeAsString(jsonString);
  }

  @override
  void initState() {
    decodeCurrentNote();
    print(products);
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        centerTitle: true,
        title: Text("$myNote", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body:  Column(
        children: [

          if (currentProducts.isEmpty)
            Column(children: [ Image.asset("assets/images/check.png"), Text("Tu compra ha sido completada\n¡Enhorabuena!",  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),           SizedBox(height : 200, child: TextButton(onPressed: (){removeHere(); int index = 2; while(index > 0 ){ index --; Navigator.pop(context);}; super.initState();}, child: Text("Borrar Nota", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),))),
            ]),


        Expanded(
        child : ListView.builder(
            itemCount: currentProducts.length,
              itemBuilder: (context, index){
              return StatefulBuilder(
                  builder: (context, setState){
                return Card(
                    color: Colors.transparent,
                    child : ListTile(
                      tileColor: Colors.transparent,
                      textColor: Colors.black,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ClipOval(
                              child: Image.file(File(currentImages[index])),
                            )
                        ),
                      ),
                      trailing: Wrap(

                        children : [
                          IconButton(
                              onPressed: (){
                                removeProductFromList(currentProducts[index], index, 1);
                              },
                              icon: Icon(Icons.remove_circle, color: Colors.red,)),
                        ],

                      ),
                      title: Text(currentProducts[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text(currentAmounts[index].toString(), style: TextStyle(color: Colors.white),),

                      onLongPress: (){
                        // Delete the entire product
                        setState(() async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Se ha borrado el producto\n${currentProducts[index]}")
                          ));

                          removeProductFromList(currentProducts[index], index, 1);
                          // Notify the user
                        });
                      },
                    ));
                  }
              );
              }
      )
    ),
    ]
      ),

    );
  }
}