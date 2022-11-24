import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'create.dart';
import 'notebook.dart';
import 'dart:convert';
import 'dart:io';
import "Glosario.dart";
import 'Register.dart';
import 'Container.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  String jsonFile = "products.json";
  String jsonString = "";
  String version = "2.6.2";
  String myNote = "";

  Map<dynamic, dynamic> products = {

    "aceites" : {
      "girasol" : ["assets/products/aceites/girasol.png", "l"],
      "oliva" : ["assets/products/aceites/oliva.jpg", "l"],
    },

    "aperitivos" : {
      "campesinas" : ["assets/products/aperitivos/campesinas.jpg", "unidad(es)"],
      "gusanitos" : ["assets/products/aperitivos/gusanitos.png", "unidad(es)"],
      "lays" : ["assets/products/aperitivos/lays.jpg", "unidad(es)"],
      "pringles" : ["assets/products/aperitivos/pringles.png", "unidad(es)"],
    },

    "carnes" : {
      "carne picada" : ["assets/products/carnes/carne_picada.jpeg", "kg"],
      "cerdo" : ["assets/products/carnes/pork.png", "kg"],
      "pate" : ["assets/products/carnes/pate.png", "unidad(es)"],
      "pollo" : ["assets/products/carnes/chicken.png", "kg"],
      "serrano" : ["assets/products/carnes/serrano.jpg", "kg"],
      "solomillo" : ["assets/products/carnes/solomillo.png", "kg"],
      "york" : ["assets/products/carnes/york.png", "kg"],
    },

    "congelados" : {
      "croquetas" : ["assets/products/congelados/croquetas.png", "unidad(es)"],
      "flamenquines" : ["assets/products/congelados/flamenquines.jpg", "unidad(es)"],
      "nuggets" : ["assets/products/congelados/nuggets.png", "unidad(es)"],
      "jacobos" : ["assets/products/congelados/jacobos.jpg", "unidad(es)"],
    },

    "dulces" : {
      "cereales" : ["assets/products/dulces/cereales.png", "unidad(es)"],
      "chocoflakes" : ["assets/products/dulces/chocoflakes.jpg", "unidad(es)"],
      "chocolate" : ["assets/products/dulces/chocolate.png", "unidad(es)"],
      "donuts" : ["assets/products/dulces/donut.jpg", "unidad(es)"],
      "galletas" : ["assets/products/dulces/galletas.png", "unidad(es)"],
      "oreo" : ["assets/products/dulces/oreo.png", "unidad(es)"]

    },

    "especias" : {
      "azúcar" : ["assets/products/especias/azucar.png", "unidad(es)"],
      "bicarbonato" : ["assets/products/especias/bicarbonato.png", "unidad(es)"],
      "harina" : ["assets/products/especias/harina.jpg", "unidad(es)"],
      "sal" : ["assets/products/especias/sal.png", "unidad(es)"]
    },

    "frutas" : {
      "arandanos" : ["assets/products/frutas/arandano.jpg", "kg"],
      "ciruelas" : ["assets/products/frutas/ciruelas.png", "kg"],
      "coco" : ["assets/products/frutas/coco.png", "unidad(es)"],
      "frambuesa" : ["assets/products/frutas/frambuesa.png","kg"],
      "fresas" : ["assets/products/frutas/fresas.jpg","kg"],
      "granada" : ["assets/products/frutas/granada.jpg","kg"],
      "kiwi" : ["assets/products/frutas/kiwi.png","kg"],
      "lima" : ["assets/products/frutas/lima.png", "kg"],
      "mandarina" : ["assets/products/frutas/mandarina.png", "kg"],
      "mango" : ["assets/products/frutas/mango.png",  "kg"],
      "manzanas" : ["assets/products/frutas/manzana.png", "kg"],
      "melon" : ["assets/products/frutas/melon.png", "kg"],
      "membrillo" : ["assets/products/frutas/membrillo.png", "kg"],
      "mermelada" : ["assets/products/frutas/mermelada.png", "kg"],
      "naranjas" : ["assets/products/frutas/naranja.png", "kg"],
      "paraguayo" : ["assets/products/frutas/paraguayo.jpg", "kg"],
      "peras" : ["assets/products/frutas/pera.png", "kg"],
      "piña" :  ["assets/products/frutas/piña.png", "kg"],
      "pomelos" : ["assets/products/frutas/pomelo.png", "kg"],
      "platanos" : ["assets/products/frutas/platanos.png", "kg"],
      "sandia" : ["assets/products/frutas/sandia.png", "kg"],
      "uvas" : ["assets/products/frutas/uvas.png", "kg"],
    },

    "frutos_secos" : {
      "almendras" : ["assets/products/frutos_secos/almendras.png", "unidad(es)"],
      "avellanas" : ["assets/products/frutos_secos/avellana.jpg", "unidad(es)"],
      "cacahuetes" : ["assets/products/frutos_secos/cacahuetes.png","unidad(es)"],
      "nueces" : ["assets/products/frutos_secos/nueces.png","unidad(es)"],
      "pipas" : ["assets/products/frutos_secos/pipas.jpg","unidad(es)"],
      "pistachos" : ["assets/products/frutos_secos/pistachos.png","unidad(es)"],
    },

    "helados" : {
      "helados" : ["assets/products/helados/helado.png", "unidad(es)"],
    },

    "higiene" : {
      "colonia" : ["assets/products/higiene/colonia.png", "unidad(es)"],
      "desodorante" : ["assets/products/higiene/desodorante.png", "unidad(es)"],
      "detergente" : ["assets/products/higiene/detergente.png","unidad(es)"],
      "jabon" : ["assets/products/higiene/jabon.png", "unidad(es)"],
      "lejia" : ["assets/products/higiene/lejia.jpg", "unidad(es)"],
      "nenuco" : ["assets/products/higiene/nenuco.jpg","unidad(es)"],
      "papel higienico" : ["assets/products/higiene/higienico.png","unidad(es)"],
      "pañales" : ["assets/products/higiene/panales.jpg","unidad(es)"],
      "toallitas" : ["assets/products/higiene/toallitas.png","unidad(es)"],
    },

    "hortalizas" : {
      "berenjena" : ["assets/products/hortalizas/berenjena.png","kg"],
      "calabacino" : ["assets/products/hortalizas/calabacino.png","kg"],
      "calabaza" : ["assets/products/hortalizas/calabaza.png","kg"],
      "cebollas" : ["assets/products/hortalizas/cebollas.png","kg"],
      "patatas" : ["assets/products/hortalizas/patatas.png","kg"],
      "pimientos" : ["assets/products/hortalizas/pimientos.png","kg"],
      "tomates" : ["assets/products/hortalizas/tomate.png","kg"],
      "zanahorias" : ["assets/products/hortalizas/zanahorias.png","kg"],
    },

    "lacteos" : {
      "desnatada" : ["assets/products/lacteos/leche_desnatada.png","unidad(es)"],
      "entera" : ["assets/products/lacteos/leche_entera.png","unidad(es)"],
      "flan" : ["assets/products/lacteos/flan.png","unidad(es)"],
      "gelatina" : ["assets/products/lacteos/gelatina.png","unidad(es)"],
      "huevos" : ["assets/products/lacteos/egg.png","unidad(es)"],
      "mantequilla" : ["assets/products/lacteos/mantequilla.png","unidad(es)"],
      "quesitos" : ["assets/products/lacteos/quesitos.png", "unidad(es)"],
      "queso" : ["assets/products/lacteos/cheese.png","unidad(es)"],
      "yogur" : ["assets/products/lacteos/yogur.jpg","unidad(es)"],

    },

    "legumbres" : {
      "alubias" : ["assets/products/legumbres/alubias.png", "kg"],
      "garbanzos" : ["assets/products/legumbres/garbanzos.png", "kg"],
      "lentejas" : ["assets/products/legumbres/lentejas.png", "kg"],
    },

    "pan" : {
      "barra" : ["assets/products/pan/barra.jpg","unidad(es)"],
      "bollos" : ["assets/products/pan/bollos.png","unidad(es)"],
      "molde" : ["assets/products/pan/molde.png", "unidad(es)"],
      "rallado" : ["assets/products/pan/rallado.png", "unidad(es)"],

    },

    "pasta" :{
      "arroz" : ["assets/products/pasta/arroz.jpg","unidad(es)"],
      "espaguetis" : ["assets/products/pasta/espaguetis.png","unidad(es)"],
      "fideos" : ["assets/products/pasta/fideos.jpg","unidad(es)"],
      "macarrones" : ["assets/products/pasta/macarrones.png","unidad(es)"],
    },

    "pescados" : {
      "atun" : ["assets/products/pescados/atun.png", "kg"],
      "bogavante" : ["assets/products/pescados/bogavante.jpg","kg"],
      "boquerones" : ["assets/products/pescados/boquerones.png","kg"],
      "caballa" : ["assets/products/pescados/caballa.jpg","kg"],
      "calamar" : ["assets/products/pescados/calamar.png","kg"],
      "bacaladillas" : ["assets/products/pescados/bacaladillas.jpg","kg"],
      "jurel" : ["assets/products/pescados/jurel.jpg","kg"],
      "lenguado" : ["assets/products/pescados/lenguado.jpg","kg"],
      "lubina" : ["assets/products/pescados/lubina.jpg","kg"],
      "merluza" : ["assets/products/pescados/merluza.png","kg"],
      "percebe" : ["assets/products/pescados/percebe.jpg","kg"],
      "rosada" : ["assets/products/pescados/rosada.png","kg"],
      "sardina" : ["assets/products/pescados/sardina.jpeg","kg"],
      "trucha" : ["assets/products/pescados/trucha.png","kg"],
    },

    "refrescos" : {
      "agua" : ["assets/products/refrescos/agua.png", "unidad(es)"],
      "aquarius" : ["assets/products/refrescos/aquarius.png","unidad(es)"],
      "blanco" : ["assets/products/refrescos/blanco.png","unidad(es)"],
      "cerveza" : ["assets/products/refrescos/cerveza.png","unidad(es)"],
      "cocacola" : ["assets/products/refrescos/cocacola.png","unidad(es)"],
      "fanta" : ["assets/products/refrescos/fanta.jpg","unidad(es)"],
      "kas" : ["assets/products/refrescos/kas.png","unidad(es)"],
      "zumo" : ["assets/products/refrescos/melocoton.jpg","unidad(es)"],
      "nestea" : ["assets/products/refrescos/nestea.png","unidad(es)"],
      "sevenup" : ["assets/products/refrescos/sevenup.jpg","unidad(es)"],
      "sprite" : ["assets/products/refrescos/sprite.jpg","unidad(es)"],
      "trina" : ["assets/products/refrescos/trina.png","unidad(es)"],
      "vino" : ["assets/products/refrescos/vino.png","unidad(es)"],
    },

    "salsas" : {
      "alioli" : ["assets/products/salsas/alioli.png", "unidad(es)"],
      "ketchup" :  ["assets/products/salsas/ketchup.png", "unidad(es)"],
      "mayonesa" : ["assets/products/salsas/mayonesa.png", "unidad(es)"],
      "mostaza" : ["assets/products/salsas/mostaza.png", "unidad(es)"],
      "frito" : ["assets/products/salsas/tomate.png", "unidad(es)"],
    },

    "shampoos" : {
      "champu" : ["assets/products/shampoos/shampoo.png","unidad(es)"],
      "gel" : ["assets/products/shampoos/gel.png","unidad(es)"],
    },

    "vegetales" :{
      "champiñones" : ["assets/products/vegetales/champinones.png","kg"],
      "setas" : ["assets/products/vegetales/setas.jpg","kg"],
    },

    "verduras" : {
      "acelgas" : ["assets/products/verduras/acelgas.jpg","kg"],
      "apio" : ["assets/products/verduras/apio.png","kg"],
      "coliflor" : ["assets/products/verduras/coliflor.png","kg"],
      "espinacas" : ["assets/products/verduras/espinacas.jpg","kg"],
      "lechuga" : ["assets/products/verduras/lechuga.png","kg"],
      "limon" : ["assets/products/verduras/limon.png","kg"],
      "puerro" : ["assets/products/verduras/puerro.png","kg"],
    },
  };

  Map<dynamic,dynamic> updateVersion = {};

  _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    await launchUrl(_url,mode: LaunchMode.externalApplication);
  }

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Espera un momento...")
      ));
      var setup = new Setup(false, products); // Create setup
      await setup.decodeImagesToBase64(); // Decode images to base64
      Restart.restartApp();
    }

  }

  updateVersionFile() async {
    final file = File("/data/user/0/com.daviiid99.shoppy_go/app_flutter/update.json");

    updateVersion["version"] = version; // add to map
    jsonString = jsonEncode(updateVersion); // encode map
    file.writeAsStringSync(jsonString); // overwrite json file
  }

  checkProductsAvailable() async {
    // Check if we're missing products by the way :)
    // We'll check a file containing the old version and compare it with latest version

    final file = File(
        "/data/user/0/com.daviiid99.shoppy_go/app_flutter/update.json");

    if (!file.existsSync()) {
      // File doesn't exists, create it with latest available version
      updateVersionFile();
    } else {
      var value = file.readAsStringSync();
      updateVersion = jsonDecode(value);

      if (updateVersion["version"] != version) {
        Setup setup = new Setup(false, products);
        if (updateVersion["version"] != version) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Agregando nuevos productos...")
          ));
          await setup.updateProducts(version, updateVersion);
          await updateVersionFile();
          Restart.restartApp();
        }
      }
    }
  }

  @override
  void initState() {
    // Set full screen mode for an inmersive experience
    setState(() async {
      await readJson();
      checkProductsAvailable();
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        appBar: AppBar(
          title: Row(children : [ Text("v$version", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),  Spacer(), TextButton.icon( onPressed : (){ _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.shoppy_go");}, style: TextButton.styleFrom(backgroundColor: Colors.deepOrange), icon: Icon(Icons.play_arrow_rounded, color: Colors.white,), label: Text(""), )],),
          elevation: 0.0,
          backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          Image.asset("assets/icon/banner.png"),
          SizedBox(height: 30,),
          Text(
              "¿Qué quieres hacer?",
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
                            MaterialPageRoute(builder: (context) => Create(products, true, myNote)));
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