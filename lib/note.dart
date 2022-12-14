import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:shoppy_go/create.dart';
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
  Map<dynamic, dynamic> cardSkin = {};
  String theme = "";


  Note(String myNote, Map<dynamic, dynamic> myNotes, Map<dynamic, dynamic> products, Map<dynamic, dynamic> cardSkin, theme){
    this.myNote = myNote;
    this.myNotes = myNotes;
    this.products = products;
    this.cardSkin = cardSkin;
    this.theme =  theme;
  }

  _NoteState createState() => _NoteState(this.myNote, this.myNotes, this.products, this.cardSkin, this.theme);
}

class _NoteState extends State<Note>{


  String theme = "";
  String myNote = "";
  String jsonString = "";
  Map<dynamic, dynamic> myNotes = {};
  Map<dynamic, dynamic> myNotesCopia = {};
  Map<dynamic, dynamic> products = {};
  Map<dynamic, dynamic> cardSkin = {};
  List<String> currentProducts = [];
  List<double> currentAmounts = [];
  List<String>  currentImages = [];
  List<String> currentUnits = [];
  List<String> temptProducts = [];
  List<double> tempAmounts = [];
  List<String>  tempImages = [];
  List<String> tempUnits = [];
  final noteName = TextEditingController();

  _NoteState(String myNote, Map<dynamic, dynamic> myNotes, Map<dynamic, dynamic> products, Map<dynamic, dynamic> cardSkin, theme){
    this.myNote = myNote;
    this.myNotes = myNotes;
    this.products = products;
    this.cardSkin = cardSkin;
    this.theme = theme;
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

  _readImage(String image) async {
    final data = await rootBundle.load(image);
    return data.buffer.asUint8List();
  }

  _currentImage() async {
    for (String imagePath in currentImages){
      var myPhoto = File(imagePath).readAsBytesSync();
      return myPhoto;
    }
  }

  generatePdf() async {
    // Create pdf
    final pdf = pw.Document();

    File logo = File("assets/icon/icon.png");
    final image = pw.MemoryImage(await _readImage(logo.path));
    final currentImage = pw.MemoryImage( await _currentImage());


    // Create pdf body
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 5,
        build: (pw.Context context) {
          return <pw.Widget>[
         pw.Center(
           child: pw.Column(
            children: [
              pw.SizedBox(height: 170),
              pw.Image(image, width: 300, height: 300),
              pw.Text("\n--------------------------------------------------------------------\n\n\n"),
              pw.Text("$myNote", style: pw.TextStyle(fontSize: 45, color: PdfColors.black,),),
            pw.Text("\n--------------------------------------------------------------------\n\n\n"),
              pw.SizedBox(height: 110),
            pw.Text("Resumen de productos",  style: pw.TextStyle(fontSize: 30, color: PdfColors.black ),),
              pw.SizedBox(height: 60),
              pw.ListView.builder(itemBuilder: (context,index)
            {
              return pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    //pw.Image(currentImage),
                    pw.Text(currentProducts[index], style: pw.TextStyle(fontSize: 30, color: PdfColors.black)),
                    pw.SizedBox(height: 20),
                    pw.Text(currentAmounts[index].toStringAsFixed(1) + " " + currentUnits[index], style : pw.TextStyle(fontSize: 30, color: PdfColors.black)),
                  ]
              ),
                pw.Row(children : [pw.Text("\n----------------------------------------------------------------------------------------------------------------------------------------\n\n\n")]),
              ]


              );

                  }

      , itemCount: currentProducts.length

            )

          ]
        )

      )];
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

  getNoteIndex(Map<dynamic, dynamic> notes, String newNote) async {

    var index = 0;
    var note_index = 0;

    // We'll need the index of the new note
    for(String note in notes.keys){
      if (note != newNote){
        index ++;
      } else {
        note_index = index;
      }
    }

    return note_index;
  }

  renameNote(String note) async {
    myNotes.remove(myNote); // Remove current note
    cardSkin.remove(myNote); // Remove current note skin
    myNotes[note] = []; // Create new note with an empty list
    final index = getNoteIndex(myNotes, note);

    Map<dynamic, dynamic> tempMap = {};

    for (String product in currentProducts){
      var index = currentProducts.indexOf(product);
      tempMap[product] = [currentImages[index], currentAmounts[index], currentUnits[index]];
    }

    // write notes hash map
    final file = await  File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/myNotes.json"); // get file path
    myNotes[note] = {};
    myNotes[note].addEntries(tempMap.entries);
    jsonString = jsonEncode(myNotes);
    file.writeAsString(jsonString);

    // write cards hash map
    final themeFile = await File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/cards.json"); // get file path
    cardSkin[note] = ""; // initialize
    cardSkin[note] = theme ; // assign theme
    jsonString = jsonEncode(cardSkin);
    themeFile.writeAsStringSync(jsonString);

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
                            Text("\Editando Nota\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
                            TextFormField(
                              textAlign: TextAlign.center,
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
                                  hintText: "Elige un nombre"), cursorColor: Colors.white, textAlignVertical: TextAlignVertical.center,
                              controller: noteName,
                              onTap: (){
                                noteName.text = "";
                              },
                            ),

                            TextButton(
                              child: Text("Guardar"),
                              onPressed: ()  async{
                                setState(() async {
                                  await renameNote(noteName.text);
                                  var index = 3;

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
        title: Row(  mainAxisAlignment: MainAxisAlignment.center, children : [ Center(child : Text("$myNote", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)) , Center(child : IconButton(onPressed: (){chooseNoteName();}, icon: Icon(Icons.edit_rounded), alignment: Alignment.center,))]),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body:  Column(
        children: [

          if (currentProducts.isEmpty)
            Column(children: [ Image.asset("assets/images/check.png"), Text("Tu compra ha sido completada\n??Enhorabuena!",  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),SizedBox(height : 200, child: TextButton(onPressed: (){removeHere(); int index = 2; while(index > 0 ){ index --; Navigator.pop(context);}; super.initState();}, child: Text("Borrar Nota", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),))),
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
                icon : Icon(Icons.edit_rounded, color: Colors.white,),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Create(products, false, myNote)));
                }),

          ),
          BottomNavigationBarItem(
            label: "",
            backgroundColor: Colors.transparent,
              icon: IconButton(
                icon : Icon(Icons.download_rounded, color: Colors.white,),
              onPressed: (){
                  setState(() async {
                    generatePdf();
                  });
              },)),

        ],
      ),

    );
  }
}