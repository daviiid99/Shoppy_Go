import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'create.dart';
import 'notebook.dart';
import 'dart:convert';
import 'dart:io';
import "Glosario.dart";
import 'Register.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  String jsonFile = "products.json";
  String jsonString = "";
  String version = "1.2";

  Map<dynamic, dynamic> products = {

    "aperitivos" : {
      "campesinas" : "assets/products/aperitivos/campesinas.jpg",
      "gusanitos" : "assets/products/aperitivos/gusanitos.png",
      "lays" : "assets/products/aperitivos/lays.jpg",
      "pringles" : "assets/products/aperitivos/pringles.png",
    },

    "carnes" : {
      "cerdo" : "assets/products/carnes/pork.png",
      "pollo" : "assets/products/carnes/chicken.png",
      "serrano" : "assets/products/carnes/serrano.jpg",
      "solomillo" : "assets/products/carnes/solomillo.png",
      "york" : "assets/products/carnes/york.png",
    },

    "dulces" : {
      "cereales" : "assets/products/dulces/cereales.png",
      "chocoflakes" : "assets/products/dulces/chocoflakes.jpg",
      "chocolate" : "assets/products/dulces/chocolate.png",
      "donuts" : "assets/products/dulces/donut.jpg",
      "galletas" : "assets/products/dulces/galletas.png",
      "oreo" : "assets/products/dulces/oreo.png",

    },

    "especias" : {
      "azucar" : "assets/products/especias/azucar.png",
      "bicarbonato" : "assets/products/especias/bicarbonato.png",
      "harina" : "assets/products/especias/harina.jpg",
      "sal" : "assets/products/especias/sal.png",
    },

    "frutas" : {
      "arandanos" : "assets/products/frutas/arandano.jpg",
      "ciruelas" : "assets/products/frutas/ciruelas.png",
      "coco" : "assets/products/frutas/coco.png",
      "frambuesa" : "assets/products/frutas/frambuesa.png",
      "fresas" : "assets/products/frutas/fresas.jpg",
      "granada" : "assets/products/frutas/granada.jpg",
      "kiwi" : "assets/products/frutas/kiwi.png",
      "lima" : "assets/products/frutas/lima.png",
      "mandarina" : "assets/products/frutas/mandarina.png",
      "mango" : "assets/products/frutas/mango.png",
      "manzana" : "assets/products/frutas/manzana.png",
      "melon" : "assets/products/frutas/melon.png",
      "mermelada" : "assets/products/frutas/mermelada.png",
      "naranja" : "assets/products/frutas/naranja.png",
      "paraguayo" : "assets/products/frutas/paraguayo.jpg",
      "pera" : "assets/products/frutas/pera.png",
      "piña" : "assets/products/frutas/piña.png",
      "platanos" : "assets/products/frutas/platanos.png",
      "sandia" : "assets/products/frutas/sandia.png",
      "uvas" : "assets/products/frutas/uvas.png",
    },

    "frutos_secos" : {
      "almendras" : "assets/products/frutos_secos/almendras.png",
      "avellanas" : "assets/products/frutos_secos/avellana.jpg",
      "cacahuetes" : "assets/products/frutos_secos/cacahuetes.png",
      "nueces" : "assets/products/frutos_secos/nueces.png",
      "pipas" : "assets/products/frutos_secos/pipas.jpg",
      "pistachos" : "assets/products/frutos_secos/pistachos.png",
    },

    "helados" : {
      "helados" : "assets/products/helados/helado.png"
    },

    "higiene" : {
      "colonia" : "assets/products/higiene/colonia.png",
      "desodorante" : "assets/products/higiene/desodorante.png",
      "detergente" : "assets/products/higiene/detergente.png",
      "jabon" : "assets/products/higiene/jabon.png",
      "lejia" : "assets/products/higiene/lejia.jpg",
      "nenuco" : "assets/products/higiene/nenuco.jpg",
      "papel higienico" : "assets/products/higiene/higienico.png",
      "pañales" : "assets/products/higiene/panales.jpg",
      "toallitas" : "assets/products/higiene/toallitas.png",
    },

    "hortalizas" : {
      "berenjena" : "assets/products/hortalizas/berenjena.png",
      "calabacino" : "assets/products/hortalizas/calabacino.png",
      "calabaza" : "assets/products/hortalizas/calabaza.png",
      "cebollas" : "assets/products/hortalizas/cebollas.png",
      "patatas" : "assets/products/hortalizas/patatas.png",
      "pimientos" : "assets/products/hortalizas/pimientos.png",
      "tomate" : "assets/products/hortalizas/tomate.png",
      "zanahorias" : "assets/products/hortalizas/zanahorias.png",
    },

    "lacteos" : {
      "desnatada" : "assets/products/lacteos/leche_desnatada.png",
      "entera" : "assets/products/lacteos/leche_entera.png",
      "flan" : "assets/products/lacteos/flan.png",
      "gelatina" : "assets/products/lacteos/gelatina.png",
      "huevos" : "assets/products/lacteos/egg.png",
      "mantequilla" : "assets/products/lacteos/mantequilla.png",
      "quesitos" : "assets/products/lacteos/quesitos.png",
      "queso" : "assets/products/lacteos/cheese.png",
      "yogur" : "assets/products/lacteos/yogur.jpg",

    },

    "legumbres" : {
      "alubias" : "assets/products/legumbres/alubias.png",
      "garbanzos" : "assets/products/legumbres/garbanzos.png",
      "lentejas" : "assets/products/legumbres/lentejas.png",
    },

    "pan" : {
      "barra" : "assets/products/pan/barra.jpg",
      "bollos" : "assets/products/pan/bollos.png",
      "molde" : "assets/products/pan/molde.png"
    },

    "pasta" :{
      "arroz" : "assets/products/pasta/arroz.jpg",
      "espaguetis" : "assets/products/pasta/espaguetis.png",
      "fideos" : "assets/products/pasta/fideos.jpg",
      "macarrones" : "assets/products/pasta/macarrones.png",
    },

    "pescados" : {
      "atun" : "assets/products/pescados/atun.png",
      "bogavante" : "assets/products/pescados/bogavante.jpg",
      "boquerones" : "assets/products/pescados/boquerones.png",
      "caballa" : "assets/products/pescados/caballa.jpg",
      "calamar" : "assets/products/pescados/calamar.png",
      "bacaladillas" : "assets/products/pescados/bacaladillas.jpg",
      "jurel" : "assets/products/pescados/jurel.jpg",
      "lenguado" : "assets/products/pescados/lenguado.jpg",
      "lubina" : "assets/products/pescados/lubina.jpg",
      "merluza" : "assets/products/pescados/merluza.png",
      "percebe" : "assets/products/pescados/percebe.jpg",
      "rosada" : "assets/products/pescados/rosada.png",
      "sardina" : "assets/products/pescados/sardina.jpeg",
      "trucha" : "assets/products/pescados/trucha.png",
    },

    "refrescos" : {
      "agua" : "assets/products/refrescos/agua.png",
      "aquarius" : "assets/products/refrescos/aquarius.png",
      "cocacola" : "assets/products/refrescos/cocacola.png",
      "fanta" : "assets/products/refrescos/fanta.jpg",
      "kas" : "assets/products/refrescos/kas.png",
      "melocoton" : "assets/products/refrescos/melocoton.jpg",
      "nestea" : "assets/products/refrescos/nestea.png",
      "sevenup" : "assets/products/refrescos/sevenup.jpg",
      "sprite" : "assets/products/refrescos/sprite.jpg",
      "trina" : "assets/products/refrescos/trina.png"
    },

    "shampoos" : {
      "champu" : "assets/products/shampoos/shampoo.png",
      "gel" : "assets/products/shampoos/gel.png",
    },

    "verduras" : {
      "acelgas" : "assets/products/verduras/acelgas.jpg",
      "apio" : "assets/products/verduras/apio.png",
      "coliflor" : "assets/products/verduras/coliflor.png",
      "espinacas" : "assets/products/verduras/espinacas.jpg",
      "lechuga" : "assets/products/verduras/lechuga.png",
      "limon" : "assets/products/verduras/limon.png",
      "puerro" : "assets/products/verduras/puerro.png",
    },
  };

  Future<String> get _LocalFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _LocalFile async {
    final path = await _LocalFilePath;
    return File("$path/$jsonFile");
  }

  writeJson() async {
    // Get local file
    final file = await _LocalFile;

    jsonString = jsonEncode(products);
    file.writeAsString(jsonString);
  }

  readJson() async {
    // Get local file
    final file = await _LocalFile;

    if (file.existsSync()){
      // Decode file
      setState(()  async {
        jsonString = file.readAsStringSync();
        products = jsonDecode(jsonString);
      });

    } else {
      writeJson();
    }

  }

  @override
  void initState() {
    // Set full screen mode for an inmersive experience
    readJson();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        appBar: AppBar(
          title: Text("v$version", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
          elevation: 0.0,
          backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          Image.asset("assets/icon/banner.png"),
          SizedBox(height: 30,),
          Text(
              "Recomendaciones",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(height: 30,),

        Expanded(
          child : SingleChildScrollView(
            child : Column(
          children: [
            SizedBox(
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
                        Text("Crear Una Nota", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text("¡Nos vamos de compras!\n", style: TextStyle(fontSize: 15),),
                        ElevatedButton(
                          child: Text("Crear Notas", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.push(
                                context,
                            MaterialPageRoute(builder: (context) => Create(products)));
                          },
                        )
                      ]
                    )
                  )
        ),
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
            ),

            SizedBox(
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
                        Text("Ver Mis Notas", style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),),
                        SizedBox(height: 5,),
                        Text("Revisa tus compras\n", style: TextStyle(fontSize: 15),),
                        ElevatedButton(
                          child: Text("Ver Notas", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Notebook(products)));
                          },
                        )
                      ]
                  ),
                )
              )
                ),
                  Positioned(
                    left: 170,
                    right: 0,
                    top: 0,
                    child: Image.asset("assets/images/read_notes.png",
                      fit: BoxFit.fitWidth,
                      height: 200,
                      width: 140,
                      scale: 0.3,

                    ),
                  )
              ]
            )
            ),
            SizedBox(
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
                                      Text("Registrar Producto", style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),),
                                      SizedBox(height: 5,),
                                      Text("Añade tus productos\n", style: TextStyle(fontSize: 15),),
                                      ElevatedButton(
                                        child: Text("Añadir Producto", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Register(products)));
                                        },
                                      )
                                    ]
                                ),
                              )
                          )
                      ),
                      Positioned(
                        left: 170,
                        right: 0,
                        top: 0,
                        child: Image.asset("assets/images/add_product.png",
                          fit: BoxFit.fitWidth,
                          height: 200,
                          width: 140,
                          scale: 0.3,

                        ),
                      )
                    ]
                )
            ),
            SizedBox(
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
                                      Text("Glosario Productos", style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),),
                                      SizedBox(height: 5,),
                                      Text("Explora los productos\n", style: TextStyle(fontSize: 15),),
                                      ElevatedButton(
                                        child: Text("Ver Glosario", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Glosario(products)));
                                        },
                                      )
                                    ]
                                ),
                              )
                          )
                      ),
                      Positioned(
                        left: 170,
                        right: 0,
                        top: 0,
                        child: Image.asset("assets/images/catalogo.png",
                          fit: BoxFit.fitWidth,
                          height: 200,
                          width: 140,
                          scale: 0.3,

                        ),
                      )
                    ]
                )
            )
              ]
       )
    )
        ),
    ]
    )
            );
    }
  }