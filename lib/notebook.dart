import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'note.dart';
import 'create.dart';

class Notebook extends StatefulWidget{
  @override
  Map<dynamic, dynamic> products = {};
  Notebook(products){
    this.products = products;
  }
  _NotebookState createState() => _NotebookState(this.products);
}

class _NotebookState extends State<Notebook>{

  Map<dynamic, dynamic> myNotes = {};
  Map<dynamic, dynamic> products = {};
  String jsonString = "";
  String jsonFile = "myNotes.json";
  List<String> notesTitles = [];

  _NotebookState(products){
    this.products = products;
  }

  Future<String> get _LocalFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _LocalFile async {
    final path = await _LocalFilePath;
    return File("$path/$jsonFile");
  }

  readNotes() async {
    // Read Current notes and create cards :)

    // Get json file source
    final file = await _LocalFile;

    // Read json file
    try {

      jsonString = file.readAsStringSync();

      // Decode map
      myNotes = await jsonDecode(jsonString);

      // Generate cards
      for (String key in myNotes.keys){
        if (notesTitles.contains(key) == false){
          setState(() async {
            notesTitles.add(key);
          });
        }
      }

      notesTitles.sort();

    } catch (e){
      print(e);
    }
  }


  confirmRemoval(String nota) async {
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
                            Text("\n¿Quieres borrar esta nota?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
                            Text("\nConfirmas el borrado de la nota $nota \n", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),

                            FittedBox(
                              child : Column (
                                children : [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent
                              ),
                              child: Text("Borrar", style: TextStyle(color: Colors.white),),
                              onPressed: ()  async{
                                setState(() async {
                                  await removeNote(nota);
                                  Navigator.pop(context);
                                });

                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.redAccent
                              ),
                              child: Text("Cancelar", style: TextStyle(color: Colors.white),),
                              onPressed: ()  async{
                                setState(() async {
                                  Navigator.pop(context);
                                });

                              },
                            )
                                ]
                              )
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

  removeNote(String nota) async {

    setState(() async {
      myNotes.remove(nota);
      var indice = notesTitles.indexOf(nota);
      notesTitles.remove(notesTitles[indice]);
    });

    // Get json file source
    final file = await _LocalFile;

    // Encode json
    jsonString = jsonEncode(myNotes);
    file.writeAsString(jsonString);

  }

  @override
  void initState() {
      readNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
      ),
        body: Column(
            children: [

              if (notesTitles.isEmpty)
                Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        Image.asset("assets/images/empty_note.png"),
                        Text("No hay ninguna nota\nPrueba a crear una\n",  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                ),

              Expanded(
                  child : ListView.builder(
                      itemCount: notesTitles.length ,
                      itemBuilder: (context, index){
                        return SizedBox(
                          height: 200,
                          child : Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                               Container(
                                height: 200,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child : Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                    color: Colors.white,
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children : [
                                              Text(notesTitles[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                              SizedBox(height: 30,),

                                              Row(
                                                children : [
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blueAccent,
                                                  padding: const EdgeInsets.all(12.0),
                                                ),
                                                child: Text("Ver Nota", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                  MaterialPageRoute(builder: (context) => Note(notesTitles[index], myNotes, products)));
                                                },
                                              ),

                                              SizedBox(width: 10,),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent,
                                                  padding: const EdgeInsets.all(12.0),
                                                ),
                                                child: Text("Borrar Nota", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  setState(() async {
                                                    confirmRemoval(notesTitles[index]);
                                                  });
                                                },
                                              )
                                                  ]
                                              ),
                                            ]
                                        )
                                    )
                                )
                                ),
                        Positioned(
                        left: 170,
                        right: 0,
                        top: 0,
                        child: Image.asset("assets/images/create_note.png",
                        fit: BoxFit.fitWidth,
                        height: 200,
                        width: 70,
                        scale: 1.2,

                        ),
                        )
                            ]
                  )
    );
  }
    )
              ),

            ]
        ),

        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Create(products)));
          },
          backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            label: "",
            backgroundColor: Colors.transparent,
    icon: IconButton(
        icon:  Icon(Icons.create_rounded, color: Colors.white,),
         onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Create(products)));
          },
    )
          )
      ],
    ),
    );
  }
}