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
  Map<dynamic, dynamic> cardSkin = {};
  final file = File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/cards.json");
  String jsonString = "";
  String jsonFile = "myNotes.json";
  int selectCardIndex = 0;
  List<String> notesTitles = [];
  List<String> currentCardsTheme = [];
  List<MaterialAccentColor> currentCardsColor = [];
  List<String> cardsImages = ["assets/cards/default.png", "assets/cards/amigos.png", "assets/cards/barbacoa.png", "assets/cards/carro.png", "assets/cards/cine.png", "assets/cards/rosa.png", "assets/cards/tienda.png"];
  List<String> cardsTitles = ["Por defecto", "Comida con Amigos", "Barbacoa", "Compra Supermercado", "Al Cine", "Comida Íntima", "De Viaje"];
  List<String> cardsDescription = ["Si es una compra omún, esta es tu tarjeta", "¿Salida con amigos o familia?\nSi vas a celebrar un evento esta es tu tarjeta", "¿Salida al campo?\nSi vas a comer al aire libre, esta es tu tarjeta", "¿Compra al supermercado? No busques más, esta es tu tarjeta", "¿Apetito cinéfilo?\nRellena tu cartón de palomitas con esta tarjeta", "¿Una comida especial\nEscoge esta nota con delicadeza", "¿Comida al aire libre?\nQue los grillos no te distraigan!"];
  List<MaterialAccentColor> cardsColors = [Colors.lightBlueAccent, Colors.purpleAccent, Colors.deepOrangeAccent, Colors.amberAccent, Colors.cyanAccent, Colors.pinkAccent, Colors.orangeAccent ];

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
      setState(() {
        notesTitles.sort();
      });

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
      cardSkin.remove(nota);
    });

    // Get json file source
    final file = await _LocalFile;

    // Encode json (Notes)
    jsonString = jsonEncode(myNotes);
    file.writeAsString(jsonString);

    // Encode json (Theme)
    overwriteCardTheme();

  }


  cardGallery() async {
    // We'll let the user to choose a custom card to describe card content

    Widget ListViewDialog(){
      return ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: cardsImages.length ,
              itemBuilder: (context, index) {
                return Container(
                  width:200,
                  height: 200,
                  color: Colors.transparent,
                 child : Column(
                    children: [
                      SizedBox(height: 100,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            currentCardsTheme[selectCardIndex] = cardsImages[index]; // Add to list
                            currentCardsColor[selectCardIndex] = cardsColors[index];
                            cardSkin[notesTitles[selectCardIndex]] = cardsImages[index]; // Add to hash map
                            overwriteCardTheme(); // Overwrite json file
                            Navigator.pop(context);
                          });

                        },
                          child : Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
                              color: cardsColors[index],
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children : [
                                    Image.asset(cardsImages[index]),
                                    Text(cardsTitles[index], style: TextStyle(fontSize: 25, color: Colors.white),),
                                    Text("\n"),
                                    Text(cardsDescription[index], style: TextStyle(fontSize: 15, color: Colors.white),),

                            ],
                                ),
                              )
                              )
                          )
                    ],
                  ),
                );
              }
      );

    }

    showDialog(
        context: context,
        builder: (context)
    {
      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: ListViewDialog(),

            );
          }
        );

      }
      );
  }

  overwriteCardTheme() async{
    //User changed his cards theme
    // We'll overwrite JSON file with the changes
    jsonString = jsonEncode(cardSkin);
    file.writeAsStringSync(jsonString);
  }

  readCardsTheme() async {
    // We'll restore cards theme from JSON if exists


    if (file.existsSync()){
      // File exists, time to restore everything
      jsonString = file.readAsStringSync();
      cardSkin = jsonDecode(jsonString);

      if (notesTitles.length > cardSkin.keys.length){
        // New cards were added since last time

        notesTitles.sort();

        for (String card in notesTitles){
          if (!cardSkin.containsKey(card)){
            cardSkin[card] = ""; // initialize note
            cardSkin[card] = cardsImages[0]; // default card
          }
        }
      }

      overwriteCardTheme(); // save changes

      List<String> sort_skins =  [];

      for (String card in cardSkin.keys){
        // Dic isn't sort in alphabetical order, we must sort it manually
        sort_skins.add(card);
      }
      sort_skins.sort();



        for (String card in sort_skins){
          currentCardsTheme.add(cardSkin[card]);
          currentCardsColor.add(cardsColors[cardsImages.indexOf(cardSkin[card])]);
      }
    } else {
      for (String cardTitle in notesTitles){
        setState(() {
          cardSkin[cardTitle] = ""; // initialize
          cardSkin[cardTitle] = cardsImages[0]; // Add default skin for existing cards
        });

        // Write file for next read
        jsonString = jsonEncode(cardSkin);
        file.writeAsStringSync(jsonString);
      }
    }

    print(currentCardsTheme);
    print(notesTitles);

  }

  cardsFileExists() async {
    if (!file.existsSync()){
      // Write file for next read
      jsonString = jsonEncode(cardSkin);
      file.writeAsStringSync(jsonString);
    }

  }

  @override
  void initState() {
    setState(() async {
      await cardsFileExists();
      await readNotes();
      readCardsTheme(); // Add images
    });
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
                                    color: currentCardsColor[index],
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children : [
                                              Text(notesTitles[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                              SizedBox(height: 30,),

                                              Row(
                                                children : [
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blueAccent,
                                                  padding: const EdgeInsets.all(12.0),
                                                ),
                                                child: Text("Ver Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                                                onPressed: () {
                                                  readNotes();
                                                  Navigator.push(
                                                      context,
                                                  MaterialPageRoute(builder: (context) => Note(notesTitles[index], myNotes, products, cardSkin, cardSkin[notesTitles[index]])));
                                                },
                                              ),

                                              SizedBox(width: 10,),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent,
                                                  padding: const EdgeInsets.all(12.0),
                                                ),
                                                child: Text("Borrar Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
                        child : InkWell(
                          onTap: (){
                            cardGallery();
                            setState(() {
                              selectCardIndex = index;
                            });
                          },
                        child: Image.asset(currentCardsTheme[index],
                        fit: BoxFit.fitWidth,
                        height: 200,
                        width: 70,
                        scale: 1.2,

                        ),
                        )
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
                MaterialPageRoute(builder: (context) => Create(products, true, "")));
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
          MaterialPageRoute(builder: (context) => Create(products, true, "")));
          },
    )
          )
      ],
    ),
    );
  }
}