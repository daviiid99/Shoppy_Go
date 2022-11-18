import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'notebook.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

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
  Map<dynamic, dynamic> myNotesCopia = {};
  Map<dynamic, dynamic> products = {};
  List<String> currentProducts = [];
  List<double> currentAmounts = [];
  List<String>  currentImages = [];
  List<String> currentUnits = [];
  List<String> temptProducts = [];
  List<double> tempAmounts = [];
  List<String>  tempImages = [];
  List<String> tempUnits = [];

  _NoteState(String myNote, Map<dynamic, dynamic> myNotes, Map<dynamic, dynamic> products){
    this.myNote = myNote;
    this.myNotes = myNotes;
    this.products = products;
  }

  decodeCurrentNote() async{

    // Assign current note to a list of elements
    for(String nota in myNotesCopia.keys){
      if (nota.contains(myNote)){
        for(String producto in myNotesCopia[nota].keys){
          setState(()  async {
            currentProducts.add(producto);
          });

        }
      }
    }
    setState(() async {
      currentProducts.sort();
    });


    for (String producto in currentProducts){
      setState(() async {
        currentImages.add(myNotesCopia[myNote][producto][0]);
        currentAmounts.add(myNotesCopia[myNote][producto][1]);
        currentUnits.add(myNotesCopia[myNote][producto][2]);
      });
    }
  }

  removeProductFromList(String myNota, String producto, int indice) async {
    setState(() {
      myNotesCopia[myNota].remove(producto);
      currentProducts = [];
      currentImages =  [];
      currentAmounts =  [];
      currentUnits = [];
    });

  }

  generatePdf() async {
    // Create pdf
    final pdf = pw.Document();

    // Create pdf body
    pdf.addPage(pw.Page(build : (pw.Context context){
      return pw.Center(
        child: pw.Column(
          children: [
            pw.Text("$myNote", style: pw.TextStyle(fontSize: 30, color: PdfColors.black)),
            pw.Text("\n--------------------------------------------------------------------\n\n\n"),
            pw.SizedBox(height: 60),
            pw.Text("Resumen de productos",  style: pw.TextStyle(fontSize: 20, color: PdfColors.black ),),
            pw.SizedBox(height: 60),
            pw.ListView.builder(itemBuilder: (context,index)
            {
              return pw.Column(
              children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    //pw.Image(pw.MemoryImage(File(currentImages[index]).readAsBytesSync())),
                    pw.Text(currentProducts[index]),
                    pw.SizedBox(height: 20),
                    pw.Text(currentAmounts[index].toStringAsFixed(1) + " " + currentUnits[index]),
                  ]
              ),
              ]


              );

                  }

      , itemCount: currentProducts.length

            )

          ]
        )

      );
    }
    )
    );

    final file = File('sdcard/download/$myNote.pdf');
    await file.writeAsBytes(await pdf.save());
    Share.shareFiles([file.path], text: "text");

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
    setState(() async{
      myNotesCopia = myNotes; // Clone of notes map
      await decodeCurrentNote();
    });
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
                                setState(()  {
                                  removeProductFromList(myNote, currentProducts[index], index);
                                  decodeCurrentNote();
                                  //decodeSafelyNote();

                                });

                              },
                              icon: Icon(Icons.remove_circle, color: Colors.red,)),
                        ],

                      ),
                      title: Text(currentProducts[index],  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text(currentAmounts[index].toStringAsFixed(1) + " " + currentUnits[index], style: TextStyle(color: Colors.white),),

                      onLongPress: (){
                        // Delete the entire product
                        setState(() async {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Se ha borrado el producto\n${currentProducts[index]}")
                          ));
                          setState(()  {
                            removeProductFromList(myNote, currentProducts[index], index);
                            decodeCurrentNote();
                            //decodeSafelyNote();
                          });

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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            label: "",
            backgroundColor: Colors.transparent,
              icon: IconButton(
                icon : Icon(Icons.download_rounded, color: Colors.white,),
              onPressed: (){
                  setState(() async {
                    generatePdf();
                  });
              },))
        ],
      ),

    );
  }
}