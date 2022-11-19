import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Setup extends StatefulWidget {

  bool exists = false;
  Map<dynamic, dynamic> products = {};
  String fileName = "";
  String fileExtension = "";
  String currentImageFinalPath = "";
  String jsonString = "";

  @override
  Setup(exists, products){
    this.exists = exists;
    this.products = products;
  }

  Future<String> get _LocalFile async{
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Map<dynamic, dynamic> products2 = {

    "aceites" : {
      "girasol" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/girasol.png", "l"],
      "oliva" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/oliva.jpg", "l"],
    },

  "aperitivos" : {
    "campesinas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/campesinas.jpg", "unidad(es)"],
    "gusanitos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/gusanitos.png", "unidad(es)"],
    "lays" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lays.jpg", "unidad(es)"],
    "pringles" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pringles.png", "unidad(es)"],
  },

  "carnes" : {
    "carne picada" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/carne_picada.jpeg", "kg"],
    "cerdo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pork.png", "kg"],
    "pate" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pate.png", "unidad(es)"],
    "pollo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/chicken.png", "kg"],
    "serrano" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/serrano.jpg", "kg"],
    "solomillo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/solomillo.png", "kg"],
    "york" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/york.png", "kg"],
  },

  "dulces" : {
    "cereales" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/cereales.png", "unidad(es)"],
    "chocoflakes" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/chocoflakes.jpg", "unidad(es)"],
    "chocolate" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/chocolate.png", "unidad(es)"],
    "donuts" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/donut.jpg", "unidad(es)"],
    "galletas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/galletas.png", "unidad(es)"],
    "oreo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/oreo.png", "unidad(es)"],

  },

  "especias" : {
    "azucar" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/azucar.png", "unidad(es)"],
    "bicarbonato" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/bicarbonato.png", "unidad(es)"],
    "harina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/harina.jpg", "unidad(es)"],
    "sal" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/sal.png", "unidad(es)"],
  },

  "frutas" : {
    "arandanos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/arandano.jpg", "kg"],
    "ciruelas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/ciruelas.png", "kg"],
    "coco" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/coco.png", "unidad(es)"],
    "frambuesa" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/frambuesa.png","kg"],
    "fresas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/fresas.jpg","kg"],
    "granada" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/granada.jpg","kg"],
    "kiwi" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/kiwi.png","kg"],
    "lima" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lima.png", "kg"],
    "mandarina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mandarina.png", "kg"],
    "mango" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mango.png",  "kg"],
    "manzana" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/manzana.png", "kg"],
    "melon" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/melon.png", "kg"],
    "membrillo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/membrillo.png", "kg"],
    "mermelada" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mermelada.png", "kg"],
    "naranja" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/naranja.png", "kg"],
    "paraguayo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/paraguayo.jpg", "kg"],
    "pera" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pera.png", "kg"],
    "piña" :  ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/piña.png", "kg"],
    "pomelos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pomelo.png", "kg"],
    "platanos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/platanos.png", "kg"],
    "sandia" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/sandia.png", "kg"],
    "uvas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/uvas.png", "kg"],
  },

  "frutos_secos" : {
    "almendras" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/almendras.png", "unidad(es)"],
    "avellanas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/avellana.jpg", "unidad(es)"],
    "cacahuetes" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/cacahuetes.png","unidad(es)"],
    "nueces" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/nueces.png","unidad(es)"],
    "pipas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pipas.jpg","unidad(es)"],
    "pistachos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pistachos.png","unidad(es)"],
  },

  "helados" : {
    "helados" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/helado.png", "unidad(es)"],
  },

  "higiene" : {
    "colonia" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/colonia.png", "unidad(es)"],
    "desodorante" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/desodorante.png", "unidad(es)"],
    "detergente" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/detergente.png","unidad(es)"],
    "lejia" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lejia.jpg", "unidad(es)"],
    "nenuco" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/nenuco.jpg","unidad(es)"],
    "papel higienico" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/higienico.png","unidad(es)"],
    "pañales" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/panales.jpg","unidad(es)"],
    "toallitas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/toallitas.png","unidad(es)"],
  },

  "hortalizas" : {
    "berenjena" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/berenjena.png","kg"],
    "calabacino" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/calabacino.png","kg"],
    "calabaza" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/calabaza.png","kg"],
    "cebollas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/cebollas.png","kg"],
    "patatas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/patatas.png","kg"],
    "pimientos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/pimientos.png","kg"],
    "tomates" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/tomate.png","kg"],
    "zanahorias" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/zanahorias.png","kg"],
},

  "lacteos" : {
    "desnatada" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/leche_desnatada.png","unidad(es)"],
    "entera" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/leche_entera.png","unidad(es)"],
    "flan" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/flan.png","unidad(es)"],
    "gelatina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/gelatina.png","unidad(es)"],
    "huevos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/egg.png","unidad(es)"],
    "mantequilla" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mantequilla.png","unidad(es)"],
    "quesitos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/quesitos.png", "unidad(es)"],
    "queso" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/cheese.png","unidad(es)"],
    "yogur" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/yogur.jpg","unidad(es)"],

  },

  "legumbres" : {
    "alubias" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/alubias.png", "kg"],
    "garbanzos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/garbanzos.png", "kg"],
    "lentejas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lentejas.png", "kg"],
  },

  "pan" : {
    "barra" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/barra.jpg","unidad(es)"],
    "bollos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/bollos.png","unidad(es)"],
    "molde" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/molde.png","unidad(es)"],
  },

  "pasta" :{
    "arroz" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/arroz.jpg","unidad(es)"],
    "espaguetis" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/espaguetis.png","unidad(es)"],
    "fideos" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/fideos.jpg","unidad(es)"],
    "macarrones" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/macarrones.png","unidad(es)"],
  },

  "pescados" : {
    "atun" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/atun.png", "kg"],
    "bogavante" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/bogavante.jpg","kg"],
    "boquerones" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/boquerones.png","kg"],
    "caballa" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/caballa.jpg","kg"],
    "calamar" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/calamar.png","kg"],
    "bacaladillas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/bacaladillas.jpg","kg"],
    "jurel" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/jurel.jpg","kg"],
    "lenguado" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lenguado.jpg","kg"],
    "lubina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lubina.jpg","kg"],
    "merluza" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/merluza.png","kg"],
    "percebe" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/percebe.jpg","kg"],
    "rosada" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/rosada.png","kg"],
    "sardina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/sardina.jpeg","kg"],
    "trucha" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/trucha.png","kg"],
  },

  "refrescos" : {
    "agua" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/agua.png", "unidad(es)"],
    "aquarius" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/aquarius.png","unidad(es)"],
    "cocacola" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/cocacola.png","unidad(es)"],
    "fanta" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/fanta.jpg","unidad(es)"],
    "kas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/kas.png","unidad(es)"],
    "zumo" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/melocoton.jpg","unidad(es)"],
    "nestea" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/nestea.png","unidad(es)"],
    "sevenup" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/sevenup.jpg","unidad(es)"],
    "sprite" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/sprite.jpg","unidad(es)"],
    "trina" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/trina.png", "unidad(es)"],
  },

  "salsas" : {
    "alioli" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/alioli.png", "unidad(es)"],
    "ketchup" :  ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/ketchup.png", "unidad(es)"],
    "mayonesa" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mayonesa.png", "unidad(es)"],
    "mostaza" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/mostaza.png", "unidad(es)"],
    "tomate" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/tomate.png", "unidad(es)"],
  },

  "shampoos" : {
    "champu" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/shampoo.png","unidad(es)"],
    "gel" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/gel.png","unidad(es)"],
  },

  "vegetales" :{
    "champiñones" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/champinones.png","kg"],
    "setas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/setas.jpg","kg"],
  },

  "verduras" : {
    "acelgas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/acelgas.jpg","kg"],
    "apio" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/apio.png","kg"],
    "coliflor" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/coliflor.png","kg"],
    "espinacas" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/espinacas.jpg","kg"],
    "lechuga" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/lechuga.png","kg"],
    "limon" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/limon.png","kg"],
    "puerro" : ["/data/user/0/com.daviiid99.shoppy_go/app_flutter/puerro.png","kg"],
  },
    };

  writeJson() async {
    // Get File path
    final path = await _LocalFile;

    // Encode map
    jsonString = jsonEncode(products2);

    // Write map into file
    File("$path/products.json").writeAsString(jsonString);
  }

  decodeImage(String filePath, String categoria, String producto) async {
    // Read image from given path
    ByteData bytes = await rootBundle.load(filePath); //load sound from assets
    Uint8List imageBytes = await bytes.buffer.asUint8List();

    // Encode to base64
    final encode64Image = await base64Encode(imageBytes);

    // Decode base64
    Uint8List  decode64Image = await  base64Decode(encode64Image);

    // Save file into data path
    await saveImage(decode64Image, categoria, producto);
  }

  getImageDetails(String imagePath) async {
    // We're gonna get image filename and extension to save it later

    // Get filename
    final file = imagePath.split("/").last;
    final splittedName = file.characters;

    fileName = "";
    fileExtension = "";

    for (String c in splittedName){
      if(splittedName.contains(".") == false){
        fileName += c;
      } else {
        fileExtension += c;
      }
    }
  }

  saveImage(Uint8List decode64image, String categoria, String producto) async {
    // Wait for user path
    final outputPath = await _LocalFile;

    // Write image to internal storage
    final file =  File("$outputPath/$fileName$fileExtension").writeAsBytesSync(decode64image);

    // Save current image path
    currentImageFinalPath = "$outputPath/$fileName$fileExtension";

  }

  decodeImagesToBase64() async {
    if(!exists){
      // Time to convert all files to base64 format
      for (String categoria in products.keys){
        for (String producto in products[categoria].keys){
          await getImageDetails(products[categoria][producto][0]);
          await decodeImage(products[categoria][producto][0], categoria, producto);
        }
      }
      writeJson();
      print("se escribio el mapa");
    }
  }


  _SetupState createState() => _SetupState(this.exists, this.products);
}

class _SetupState extends State<Setup>{
  @override

  bool exists = false;
  Map<dynamic, dynamic> products = {};
  String fileName = "";
  String fileExtension = "";
  String currentImageFinalPath = "";
  String jsonString = "";

@override
_SetupState(exists, products){
    this.exists = exists;
    this.products = products;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}