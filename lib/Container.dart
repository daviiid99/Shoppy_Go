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
    "aperitivos" : {
      "campesinas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/campesinas.jpg",
      "gusanitos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/gusanitos.png",
      "lays" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lays.jpg",
      "pringles" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pringles.png",
    },

    "carnes" : {
      "cerdo" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pork.png",
      "pollo" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/chicken.png",
      "serrano" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/serrano.jpg",
      "solomillo" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/solomillo.png",
      "york" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/york.png",
    },

    "dulces" : {
      "cereales" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/cereales.png",
      "chocoflakes" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/chocoflakes.jpg",
      "chocolate" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/chocolate.png",
      "donuts" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/donut.jpg",
      "galletas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/galletas.png",
      "oreo" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/oreo.png",

    },

    "especias" : {
      "azucar" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/azucar.png",
      "bicarbonato" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/bicarbonato.png",
      "harina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/harina.jpg",
      "sal" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/sal.png",
    },

    "frutas" : {
      "arandanos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/arandano.jpg",
      "ciruelas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/ciruelas.png",
      "coco" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/coco.png",
      "frambuesa" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/frambuesa.png",
      "fresas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/fresas.jpg",
      "granada" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/granada.jpg",
      "kiwi" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/kiwi.png",
      "lima" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lima.png",
      "mandarina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/mandarina.png",
      "mango" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/mango.png",
      "manzana" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/manzana.png",
      "melon" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/melon.png",
      "mermelada" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/mermelada.png",
      "naranja" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/naranja.png",
      "paraguayo" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/paraguayo.jpg",
      "pera" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pera.png",
      "piña" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/piña.png",
      "platanos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/platanos.png",
      "sandia" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/sandia.png",
      "uvas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/uvas.png",
    },

    "frutos_secos" : {
      "almendras" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/almendras.png",
      "avellanas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/avellana.jpg",
      "cacahuetes" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/cacahuetes.png",
      "nueces" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/nueces.png",
      "pipas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pipas.jpg",
      "pistachos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pistachos.png",
    },

    "helados" : {
      "helados" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/helado.png"
    },

    "higiene" : {
      "colonia" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/colonia.png",
      "desodorante" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/desodorante.png",
      "detergente" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/detergente.png",
      "jabon" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/jabon.png",
      "lejia" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lejia.jpg",
      "nenuco" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/nenuco.jpg",
      "papel higienico" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/higienico.png",
      "pañales" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/panales.jpg",
      "toallitas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/toallitas.png",
    },

    "hortalizas" : {
      "berenjena" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/berenjena.png",
      "calabacino" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/calabacino.png",
      "calabaza" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/calabaza.png",
      "cebollas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/cebollas.png",
      "patatas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/patatas.png",
      "pimientos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/pimientos.png",
      "tomate" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/tomate.png",
      "zanahorias" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/zanahorias.png",
    },

    "lacteos" : {
      "desnatada" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/leche_desnatada.png",
      "entera" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/leche_entera.png",
      "flan" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/flan.png",
      "gelatina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/gelatina.png",
      "huevos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/egg.png",
      "mantequilla" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/mantequilla.png",
      "quesitos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/quesitos.png",
      "queso" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/cheese.png",
      "yogur" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/yogur.jpg",

    },

    "legumbres" : {
      "alubias" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/alubias.png",
      "garbanzos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/garbanzos.png",
      "lentejas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lentejas.png",
    },

    "pan" : {
      "barra" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/barra.jpg",
      "bollos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/bollos.png",
      "molde" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/molde.png"
    },

    "pasta" :{
      "arroz" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/arroz.jpg",
      "espaguetis" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/espaguetis.png",
      "fideos" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/fideos.jpg",
      "macarrones" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/macarrones.png",
    },

    "pescados" : {
      "atun" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/atun.png",
      "bogavante" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/bogavante.jpg",
      "boquerones" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/boquerones.png",
      "caballa" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/caballa.jpg",
      "calamar" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/calamar.png",
      "bacaladillas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/bacaladillas.jpg",
      "jurel" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/jurel.jpg",
      "lenguado" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lenguado.jpg",
      "lubina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lubina.jpg",
      "merluza" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/merluza.png",
      "percebe" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/percebe.jpg",
      "rosada" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/rosada.png",
      "sardina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/sardina.jpeg",
      "trucha" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/trucha.png",
    },

    "refrescos" : {
      "agua" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/agua.png",
      "aquarius" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/aquarius.png",
      "cocacola" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/cocacola.png",
      "fanta" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/fanta.jpg",
      "kas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/kas.png",
      "melocoton" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/melocoton.jpg",
      "nestea" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/nestea.png",
      "sevenup" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/sevenup.jpg",
      "sprite" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/sprite.jpg",
      "trina" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/trina.png"
    },

    "shampoos" : {
      "champu" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/shampoo.png",
      "gel" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/gel.png",
    },

    "verduras" : {
      "acelgas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/acelgas.jpg",
      "apio" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/apio.png",
      "coliflor" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/coliflor.png",
      "espinacas" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/espinacas.jpg",
      "lechuga" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/lechuga.png",
      "limon" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/limon.png",
      "puerro" : "/data/user/0/com.daviiid99.shoppy_go/app_flutter/puerro.png",
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
          await getImageDetails(products[categoria][producto]);
          await decodeImage(products[categoria][producto], categoria, producto);
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