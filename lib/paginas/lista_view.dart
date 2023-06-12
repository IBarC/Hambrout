import 'package:flutter/material.dart';
import 'package:hambrout/firebase/conexion_firebase.dart';
import 'package:hambrout/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../enum/enum_listas.dart';
import '../models/lista.dart';
import '../utils/formatos_disenio.dart';

/// Clase que genera la vista de Lista
class ListaWidget extends StatefulWidget{
  final Lista lista;
  final bool esNueva;

  const ListaWidget({super.key, required this.lista, required this.esNueva});

  @override
  State<StatefulWidget> createState() => ListaState(lista: lista, esNueva: esNueva);

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
  late int tamanioListView;

  @override
  void initState() {
    super.initState();
    if(!esNueva){
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

  ///Determina que hace la vista cuando termina la edición del TextField
  void terminaEdicion(Elemento elemento){
    if(lista.elementos.last==elemento && elemento.controlador.text !=''){
      lista.elementos.add(Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: '')));
      setState(() {});
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      elemento.nombre==elemento.controlador.text;
      currentFocus.focusInDirection(TraversalDirection.down);
    }
  }

  void inicializar()async{
    prefs = await SharedPreferences.getInstance();
    id=prefs.getInt(listas(DatosListas.id))??1;
  }

  ///Crea un TextField en base a si esta tachado
  Widget crearElemento(var elemento, double tam){
    if(elemento.tachado){
      return TextFormField(
          decoration: InputDecoration(
              icon: IconButton(onPressed: () {elemento.tachado=false;setState(() {});}, icon: const Icon(Icons.check_box_outlined), color: Colors.orange,)
          ),
          style: const TextStyle(decoration: TextDecoration.lineThrough),
          controller: elemento.controlador,
          onEditingComplete: (){terminaEdicion(elemento);});
    }
    return TextFormField(
        decoration: InputDecoration(
            icon: IconButton(onPressed: () {elemento.tachado=true;setState(() {});}, icon: const Icon(Icons.crop_square), color: Colors.orange,)
        ),
        controller: elemento.controlador,
        onEditingComplete: (){terminaEdicion(elemento);});//,],)
  }

  List<Widget> crearElementos(double tam){
    List<Widget> array=[];
    for(var elem in lista.elementos){
      array.add(crearElemento(elem, tam));
    }
    return array;
  }

  ///Compruba si la lista tiene elementos
  bool esListaVacia(){
    for(var e in lista.elementos){
      e.nombre=e.controlador.text;
      if(e.nombre!='' || e.nombre != ' '){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    double tamanioTextField = media.width/1.5;
    tamanioListView = lista.elementos.length;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          onTap: () {
            if(lista.elementos.last.controlador.text==''){ //Saca de la lista el ultimo elemento si es vacio
              lista.elementos.removeLast();
            }
            lista.titulo=tituloController.text;
            if(!esListaVacia()) {
              if(_formKey.currentState!.validate()){
                if(esNueva){
                  ConexionDatos().guardarListaNueva(lista);
                } else {
                  ConexionDatos().guardarLista(lista);
                }
                keys[2].currentState!.refreshPage();
                Navigator.pop(context);
              }
            }
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Form(
          key: _formKey,
          child: TextFormField(
            decoration: const InputDecoration(hintText: 'Titulo'),
            style: FormatosDisenio().txtTituloLista(context),
            controller: tituloController, validator: (value) {
            if (value!.isEmpty) {
              return 'El titulo necesita un valor';
            }
            return null;},
          ),
        ),
      ),
      body: Container(
          height: media.height,
          width: media.width-media.height/50,
          margin: MediaQuery.of(context).viewInsets,
          child: ListView(
              padding: EdgeInsets.only(top: media.height/50,left: media.height/50,right: media.height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children:
                  crearElementos(tamanioTextField)
          )
      ) ,
    );
  }

}