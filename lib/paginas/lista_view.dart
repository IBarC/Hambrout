import 'package:flutter/material.dart';
import 'package:hambrout/main.dart';
import 'package:hambrout/paginas/casa_view.dart';
import 'package:hambrout/paginas/pagina_base_view.dart';

import '../enum/enum_listas.dart';
import '../models/lista.dart';

class ListaWidget extends StatefulWidget{
  final Lista lista;

  const ListaWidget({super.key, required this.lista});

  @override
  State<StatefulWidget> createState() {
    return _Lista(lista: lista);
  }
}

class _Lista extends State<ListaWidget>{
  Lista lista;

  _Lista({required this.lista});

  final Elemento elementoVacio = Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: ''));

  late TextEditingController tituloController;

  void terminaEdidion(Elemento elemento){
    if(lista.elementos.last==elemento && elemento.controlador.text !=''){
      lista.elementos.add(elementoVacio);
      setState(() {});
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    lista.elementos.add(Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: '')));
    tituloController = TextEditingController(text: lista.titulo);
  }

  Widget crearElemento(var elemento, double tam){
    if(elemento.tachado){
      return Row(
        children: [
          Column(children: [IconButton(onPressed: (){
            elemento.tachado=false;setState(() {});},
              icon: Icon(Icons.check_box_outlined))],),
          Column(children: [SizedBox(width: tam, child: TextFormField(
              style: const TextStyle(decoration: TextDecoration.lineThrough),
              enabled: false,
              controller: elemento.controlador,
              onEditingComplete: (){terminaEdidion(elemento);}),)],)
        ],
      );
    }
    return Row(
      children: [
        Column(children: [IconButton(onPressed: (){
          elemento.tachado=true;setState(() {});},
            icon: Icon(Icons.crop_square))],),
        Column(children: [SizedBox(width: tam, child: TextFormField(
            controller: elemento.controlador,
            onEditingComplete: (){terminaEdidion(elemento);}),)],)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    double tamanioElemento = media.height/19;
    double tamanioTextField = media.width/1.2;

    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ IconButton(onPressed: (){
                  if(lista.elementos.last.controlador.text==''){
                    lista.elementos.removeLast();
                  }
                  lista.titulo=tituloController.text;
                  conexionDatos.guardarListas(lista);
                  keys[2].currentState!.refreshPage();
                  Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Row(children: [SizedBox(width: tamanioTextField, child: TextFormField(
                  controller: tituloController,
                  ),)],),
              SizedBox(
                height: (tamanioElemento)*lista.elementos.length,
                child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: lista.elementos.length,
                    itemBuilder: (context, index){
                      return crearElemento(lista.elementos[index],tamanioTextField);
                    }
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }

}