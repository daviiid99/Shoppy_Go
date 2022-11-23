import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


class Create extends StatefulWidget{
  @override
  Map<dynamic, dynamic> products = {};
  bool isEmpty = true;
  String myNote = "";

  Create(products, isEmpty, myNote) {
    this.products = products;
    this.isEmpty = isEmpty;
    this.myNote = myNote;
  }

    _CreateState createState() => _CreateState(this.products, this.isEmpty, this.myNote);
}

class _CreateState extends State<Create>{

  Map<dynamic, dynamic> products = {};
  Map<dynamic, dynamic> myNotes = {};
  String jsonString = "";
  String jsonFile = "myNotes.json";
  bool isEmpty = true;
  String myNote = "";

  _CreateState(products, isEmpty, myNote ) {
    this.products = products;
    this.isEmpty = isEmpty;
    this.myNote = myNote;

  }

  final product = TextEditingController();
  final noteName = TextEditingController();
  List<String> currentFood = [];
  List<double> currentFoodAmount = [];
  List<String> currentImages = [];
  List<String> currentFoodUnits = [];
  String hint = "Escribe un producto";

  Future<String> get _LocalFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _LocalFile async {
    final path = await _LocalFilePath;
    return File("$path/$jsonFile");
  }

  addProductToList(String producto) async {
    // Transform producto to lowercase
    var miProducto = producto.toLowerCase(); // User might use different combinations
    var splittedList = [];
    var splittedProduct = miProducto.split(" ");
    splittedList = splittedProduct.toList();
    var remaining = products.keys.length;

    // We'll check if the user product exists in our database
    for (String key in products.keys) {
      remaining --;
      for (String subKey in products[key].keys) {
        if (miProducto == subKey) {
          // CASE 1
          //PRODUCT EXISTS WITH THE SAME NAME SCHEME
          checkProductType(producto, products[key][subKey][1], key, subKey);
        }
        else if (splittedList[0] == subKey) {
          // CASE 2
          // FIRST PRODUCT WORD CONTAINS A PRODUCT
          if (splittedList[1] == "de") {
            if (splittedList[0] + splittedList[1] + splittedList[2] == subKey) {
              for (String categoria in products.keys){
                if (products[categoria].containsKey(splittedList[2])){
                }
              }
              var another_full_product = splittedList[0] + splittedList[1] +
                  splittedList[2];
              // CASE 3
              // FIRST PRODUCT WORD CONTAINS A PRODUCT, CONTAINS A CONNECTOR AND WITH NEXT WORD FORMS A COMPLETE PRODUCT
              setState(() async {
                if (remaining > 0) {
                  checkProductType(
                      producto, products[key][another_full_product][1], key,
                      another_full_product);
                }
              });
            } else {
              setState(() async {
                if (remaining > 0) {
                  checkProductType(
                      producto, products[key][splittedList[0]][1], key,
                      splittedList[0]);
                }
              });
            }
          } else {
              // IF ONLY A TARGET PRODUCT WAS FOUND
              setState(() async {
                if (remaining > 0) {
                  checkProductType(
                      producto, products[key][splittedList[0]][1], key,
                      splittedList[0]);
                }
              });
          }
        } else if (splittedList.length >= 2 ) {
            if (splittedList[0] != subKey) {
              // CASE 4
              // THERE'S A PRODUCT ONLY IN THE SECOND/THIRD/.. WORD
              setState(() async {
                for (String pr in splittedList){
                  if (pr == subKey){
                    checkProductType(producto, products[key][pr][1], key, pr);
                  }
                }
              });
          }
        }

    }
  }
  }

  checkProductType(String producto, String unidad, String categoria, String product) async {
    // We'll check if the current product match a unit

    setState(() async {
      if (currentFood.contains(producto)){
        // The product exists
        // We'll increase the measure
        final index = currentFood.indexOf(producto);

        if (currentFoodAmount[index].toString().contains(".") ){
          currentFoodAmount[index] += 1.0;
        } else {
          currentFoodAmount[index] += 1;
        }


      }
      else {
        currentFood.add(producto); // Add product name
        currentImages.add(products[categoria][product][0]); // Add image for current product
        currentFoodUnits.add(products[categoria][product][1]); // Add unit for current product
        if (products[categoria][product][1].contains("unidad(es)")){
          currentFoodAmount.add(1);
        } else if (products[categoria][product][1].contains("kg")){
          currentFoodAmount.add(1.0);
        } else if (products[categoria][product][1].contains("l")){
          currentFoodAmount.add(1.0);
        }
      }
    });

  }

  machineLearning(List<dynamic> splittedProduct, String product) {
    // User can try to add existing products with different syntax so we'll try to predict it
    // The program can't manually handle all types of products so let's do it possible to predict it

    if (splittedProduct.contains("pan") ) {
      // User forgot to set the bread size
      setState(() async {
        if (currentFood.contains(product)) {
          final index = currentFood.indexOf(product);
          currentFoodAmount[index] ++;
        } else {
          currentFood.add(product);
          currentFoodAmount.add(1);
          currentImages.add(products["pan"]["barra"][0]); // default bread size
          currentFoodUnits.add(products["pan"]["barra"][1]);
        }
      });

    } else if (splittedProduct.contains("leche")) {
      // User forgot to set the type of milk
      setState(() async {
        if (currentFood.contains(product)) {
          final index = currentFood.indexOf(product);
          currentFoodAmount[index] ++;
        } else {
          currentFood.add(product);
          currentFoodAmount.add(1);
          currentImages.add(
              products["lacteos"]["entera"][0]); // default bread size
          currentFoodUnits.add(products["lacteos"]["entera"][1]);

        }
      });

    } else if (splittedProduct.contains("carne") && !splittedProduct.contains("pollo") && !splittedProduct.contains("cerdo")) {
      // User forgot to specify meat type
      setState(() async {
        if (currentFood.contains(product)) {
          final index = currentFood.indexOf(product);
          currentFoodAmount[index] ++;
        } else {
          currentFood.add(product);
          currentFoodAmount.add(1.0);
          currentImages.add(products["carnes"]["pollo"][0]); // default bread size
          currentFoodUnits.add(products["carnes"]["pollo"][1]);

        }
      });
    }
  }

  removeEverything() async {
    currentFood.clear();
    currentImages.clear();
    currentFoodAmount.clear();
  }

  removeProductFromList(String product, int indice, double amount, String unit, String unidad) async {
    // We'll delete the choosed product or decrease his amount!
    if (amount == 0 && unidad.contains("unidad(es)") || amount <= 0.1 && unidad.contains("kg") || amount == 1 && unidad.contains("unidad(es)") || amount <= 0.1 && currentFoodUnits[indice].contains("l")){
      // We wont to remove it from list
      setState(() async {
        currentFoodUnits.removeAt(indice);
        currentFood.removeAt(indice);
        currentFoodAmount.removeAt(indice);
        currentImages.removeAt(indice);
      });
    } else {
      setState(() async {
        if (unit.contains("kg") || unit.contains("l")){
          currentFoodAmount[indice] -= 0.1;
        } else {
          currentFoodAmount[indice]  -=1 ;
        }
      });
    }

  }

  addProductFromList(String product, int indice, double amount, String unit) async {
    // We'll increase the amount of the current product
    // In this step, we'll check the type of product
    setState(() async {
      if(unit.contains("kg") || unit.contains("l")){
        currentFoodAmount[indice] += 0.1;
      } else {
        currentFoodAmount[indice] ++;
      }
    });
  }
  
  chooseNoteName() async {

    var message = "*Este nombre puede modificarse más tarde";
    var message_color = Colors.white;
    
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
                        Text("\nGuardando Nota\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),
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

                        Text("\n$message\n", style: TextStyle(color: message_color, fontSize: 10, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,),

                        TextButton(
                          child: Text("Guardar"),
                          onPressed: ()  async{
                            setState(() async {
                              if(noteName.text.length > 0){
                                // An empty note isn't allowed since it could lead to unexpected situations

                                if (myNotes.containsKey(noteName.text) && !message.contains("Esta nota ya existe,si quieres sobreescribirla pulsar 'Guardar'" )){
                                    // Modify an existing note is allowed but user should be notified about it before
                                    // We show an alert and user will be prompted to proceed or decline it
                                    message = "Esta nota ya existe,si quieres sobreescribirla pulsar 'Guardar' ";
                                    message_color = Colors.red;

                                    }

                                else {
                                  if(myNotes.containsKey(noteName.text)){
                                    restoreNoteProducts(noteName.text); // This is only needed for exiting notes to preserve all items
                                    myNotes.remove(noteName.text);
                                  }

                                  await encodeProductsIntoMap(noteName.text);
                                  var index = 2;

                                  while (index > 0){
                                    index -=1;
                                    Navigator.pop(context);
                                  }
                              }

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


  encodeProductsIntoMap(String note) {
    // Our map have to represent the current status of our products list

    Map<dynamic, dynamic> tempMap = {};

      for (String product in currentFood){
        if (myNotes.containsKey(note) == false){
          var index = currentFood.indexOf(product);
          tempMap[product] = [currentImages[index], currentFoodAmount[index], currentFoodUnits[index]];
        } else {
        }
      }

      myNotes[note] = {};
      myNotes[note].addEntries(tempMap.entries);

    writeJson();
  }

  writeJson() async {
    // Get dir path
    final file = await _LocalFile; // Get local path

    // Encode current map into a string
    jsonString = jsonEncode(myNotes);

    // Save current map into a json file on internal directory
    file.writeAsString(jsonString);
  }

  readJson() async {
    // Get dir path
    final file = await _LocalFile; // Get local path

    // Get file content
    jsonString = await file.readAsStringSync();

    //Decode JSON file
    myNotes = jsonDecode(jsonString);
  }

  restoreNoteProducts(String nota) async {
    // We want the user to be able to edit an older note
    // This will allow to the user to add or remove products if needed without creating a new note from scratch

    for (String product in myNotes[nota].keys ){
      setState(() {
        currentFood.add(product); // product
        currentImages.add(myNotes[nota][product][0]); // image
        currentFoodAmount.add(myNotes[nota][product][1]); // amount ;
        currentFoodUnits.add(myNotes[nota][product][2]);
      });
    }
  }

  @override
  void initState(){
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);


    setState(() async {
      await readJson();
      if (!isEmpty){
        restoreNoteProducts(myNote);
      }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          if (currentFood.isNotEmpty)
            SizedBox(
              height: 120,
            child : SizedBox(
              width: double.infinity,
              height: 40,
              child : TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black45,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Text("Guardar Nota", style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  if(myNote.isEmpty){
                    chooseNoteName();
                  } else {
                    myNotes.remove(myNote); // This is needed to overrite it first
                    await encodeProductsIntoMap(myNote);
                    var index = 2;
                    while (index > 0) {
                      index -=1;
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
            ),

          if (currentFood.isEmpty)
            Expanded(
            child: Column(children: [
              SizedBox(height: 60,),
            Image.asset("assets/images/empty_basket.png"), Text("Tu cesta esta vacía\nAñade algun producto", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)])),

          Expanded(
          child : ListView.builder(
            itemCount: currentFood.length ,
              itemBuilder: (context, index){
              return StatefulBuilder(
              builder: (context, setState)
              {
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
                          removeProductFromList(currentFood[index], index, currentFoodAmount[index], currentFoodUnits[index], currentFoodUnits[index]);

                        },
                        icon: Icon(Icons.remove, color: Colors.white,)),

                    IconButton(
                      onPressed: (){
                        addProductFromList(currentFood[index], index, currentFoodAmount[index], currentFoodUnits[index]);


                      }, icon: Icon(Icons.add, color: Colors.white,),),
                  ],

                ),
                title: Text(currentFood[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                subtitle: Text(currentFoodAmount[index].toStringAsFixed(1) + " " + currentFoodUnits[index] , style: TextStyle(color: Colors.white),),

                onLongPress: (){
                  // Delete the entire product
                  setState(() async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Se ha borrado el producto\n${currentFood[index]}")
                    ));
                   removeProductFromList(currentFood[index], index, 0, currentFoodUnits[index], currentFoodUnits[index]);
                   // Notify the user
                    });
                },
              ));
              }
              );
                }
              )
          ),

          TextFormField(
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(12.0)
                ),

                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(12.0)
                ),
                border: OutlineInputBorder(
                ),
                hintText: hint), cursorColor: Colors.white,
            controller: product,
            onTap: (){
            },
            keyboardType: TextInputType.name,

          ),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 75,
            child : TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45,
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text("Añadir", style: TextStyle(color: Colors.white),),
              onPressed: () async{
                await addProductToList(product.text);
                FocusManager.instance.primaryFocus?.unfocus();
                product.text = "";
              },
            ),
          ),


          SizedBox(height: 30,)

        ]
    )
    );
              }
  }