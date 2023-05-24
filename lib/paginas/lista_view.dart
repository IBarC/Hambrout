import 'package:flutter/material.dart';
import 'package:hambrout/main.dart';
import 'package:hambrout/paginas/casa_view.dart';
import 'package:hambrout/paginas/pagina_base_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../enum/enum_listas.dart';
import '../models/lista.dart';

class ListaWidget extends StatefulWidget{
  final Lista lista;
  final bool esNueva;

  const ListaWidget({super.key, required this.lista, required this.esNueva});

  @override
  State<StatefulWidget> createState() {
    return ListaState(lista: lista, esNueva: esNueva);
  }
}

class ListaState extends State<ListaWidget>{
  Lista lista;
  bool esNueva;

  ListaState({required this.lista, required this.esNueva});

  final Elemento elementoVacio = Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: ''));

  late TextEditingController tituloController;
  final _formKey = GlobalKey<FormState>();

  late int id;
  late SharedPreferences prefs;
  late double tamanioListView;

  @override
  void initState() {
    super.initState();
    if(lista.elementos[0]!=elementoVacio){
      lista.elementos.add(Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: '')));
    }
    tituloController = TextEditingController(text: lista.titulo);
    inicializar();
    BackButtonInterceptor.add(interceptor);
    setState(() {});
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  void terminaEdidion(Elemento elemento){
    if(lista.elementos.last==elemento && elemento.controlador.text !=''){
      lista.elementos.add(Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: '')));
      setState(() {});
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
    }
  }

  void inicializar()async{
    prefs = await SharedPreferences.getInstance();
    id=prefs.getInt(l(DatosListas.id))??3;
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

  bool esListaVacia(){
    for(var e in lista.elementos){
      if(e.nombre!=''){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    double tamanioElemento = media.height/19;
    double tamanioTextField = media.width/1.5;
    tamanioListView = (tamanioElemento)*lista.elementos.length;

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
                  if(!esListaVacia()) {
                    if(_formKey.currentState!.validate()){
                      if(esNueva){
                        conexionDatos.guardarListaNueva(lista);
                      } else {
                        conexionDatos.guardarListas(lista);
                      }
                      keys[2].currentState!.refreshPage();
                    }
                  } else{
                    //prefs.setInt(l(DatosListas.id), id--);
                  }
                  Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Form(
                key: _formKey,
                child: Row(children: [SizedBox(width: tamanioTextField, child: TextFormField(
                  controller: tituloController, validator: (value) {
                  if (value!.isEmpty) {
                    return 'El titulo necesita un valor';
                  }
                  return null;},
                ),)],),
              ),
              SizedBox(
                height: tamanioListView,
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