import 'package:flutter/material.dart';
import 'package:hambrout/paginas/casa.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class RecetaWidget extends StatefulWidget{
  String nombre;
  List ingredientes;
  int npersonas;
  String origen;
  String tiempo;
  String tipo;
  String foto;
  List elaboracion;
  String dificultad;

  RecetaWidget({
   required this.nombre, required this.ingredientes, required this.npersonas,
    required this.origen, required this.tiempo, required this.tipo, required this.foto,
    required this.elaboracion, required this.dificultad
  });

  @override
  State<StatefulWidget> createState() {
    return _Receta(dificultad: this.dificultad, elaboracion: this.elaboracion,
      foto: this.foto, ingredientes: this.ingredientes, nombre: this.nombre,
      npersonas: this.npersonas, origen: this.origen, tiempo: this.tiempo, tipo: this.tipo
    );
  }
}

class _Receta extends State<RecetaWidget>{
  String nombre;
  List ingredientes;
  int npersonas;
  String origen;
  String tiempo;
  String tipo;
  String foto;
  List elaboracion;
  String dificultad;

  _Receta({
    required this.nombre, required this.ingredientes, required this.npersonas,
    required this.origen, required this.tiempo, required this.tipo, required this.foto,
    required this.elaboracion, required this.dificultad
  });

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        decoration: BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Row()
            ],
          ),
        ),
      ) ,
    );
  }


}