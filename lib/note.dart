import 'package:flutter/material.dart';

class Note extends StatefulWidget{
  @override

  String myNote = "";
  Map<dynamic, dynamic> myNotes = {};

  Note(String myNote, Map<dynamic, dynamic> myNotes){
    this.myNote = myNote;
    this.myNotes = myNotes;
  }

  _NoteState createState() => _NoteState(this.myNote, this.myNotes);
}

class _NoteState extends State<Note>{

  String myNote = "";
  Map<dynamic, dynamic> myNotes = {};
  List<String> currentProducts = [];
  List<int> currentAmounts = [];
  List<String>  currentImages = [];

  _NoteState(String myNote, Map<dynamic, dynamic> myNotes){
    this.myNote = myNote;
    this.myNotes = myNotes;
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

  void initState() {
    decodeCurrentNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body:  Column(
        children: [
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
                              child: Image.asset(currentImages[index]),
                            )
                        ),
                      ),
                      trailing: Wrap(

                        children : [
                          IconButton(
                              onPressed: (){
                                removeProductFromList(currentProducts[index], index, currentAmounts[index]);
                              },
                              icon: Icon(Icons.remove, color: Colors.white,)),
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