import 'package:flutter/material.dart';
import 'package:hambrout/main.dart';
import 'package:hambrout/utils/formularios.dart';
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
  late int tamanioListView;

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
      elemento.nombre==elemento.controlador.text;
      currentFocus.unfocus();
    }
  }

  void inicializar()async{
    prefs = await SharedPreferences.getInstance();
    id=prefs.getInt(l(DatosListas.id))??1;
  }

  Widget crearElemento(var elemento, double tam){
    if(elemento.tachado){
      return /**Row(
        children: [
          Column(children: [IconButton(onPressed: (){
            elemento.tachado=false;setState(() {});},
              icon: const Icon(Icons.check_box_outlined, color: Colors.orange,))],),
          Column(children: [SizedBox(width: tam, child: TextFormField(
              style: const TextStyle(decoration: TextDecoration.lineThrough),
              enabled: false,
              controller: elemento.controlador,
              onEditingComplete: (){terminaEdidion(elemento);}),)],)
        ],
      );**/TextFormField(
          decoration: InputDecoration(
              icon: IconButton(onPressed: () {elemento.tachado=false;setState(() {});}, icon: Icon(Icons.check_box_outlined), color: Colors.orange,)
          ),
          style: const TextStyle(decoration: TextDecoration.lineThrough),
          //enabled: false,
          controller: elemento.controlador,
          onEditingComplete: (){terminaEdidion(elemento);});
    }
    return //Row(
      //children: [
        /**Column(children: [IconButton(onPressed: (){
          elemento.tachado=true;setState(() {});},
            icon: const Icon(Icons.crop_square, color: Colors.orange,))],),**/
        //Column(children: [
          TextFormField(
          decoration: InputDecoration(
              icon: IconButton(onPressed: () {elemento.tachado=true;setState(() {});}, icon: Icon(Icons.crop_square), color: Colors.orange,)
          ),
            controller: elemento.controlador,
            onEditingComplete: (){terminaEdidion(elemento);});//,],)
      //],
    //);
  }

  List<Widget> crearElementos(double tam){
    List<Widget> array=[];
    for(var elem in lista.elementos){
      array.add(crearElemento(elem, tam));
    }
    return array;
  }

  bool esListaVacia(){
    for(var e in lista.elementos){
      e.nombre=e.controlador.text;
      if(e.nombre!=''){
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
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          onTap: () {
            if(lista.elementos.last.controlador.text==''){
              lista.elementos.removeLast();
            }
            lista.titulo=tituloController.text;
            if(!esListaVacia()) {
              if(_formKey.currentState!.validate()){
                if(esNueva){
                  conexionDatos.guardarListaNueva(lista);
                } else {
                  conexionDatos.guardarLista(lista);
                }
                keys[2].currentState!.refreshPage();
              }
            } else{
              //prefs.setInt(l(DatosListas.id), id--);
            }
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Form(
          key: _formKey,
          child: TextFormField(
            decoration: const InputDecoration(hintText: 'Titulo'),
            style: formatosDisenio.txtTituloLista(context),
            controller: tituloController, validator: (value) {
            if (value!.isEmpty) {
              return 'El titulo necesita un valor';
            }
            return null;},
          ),
        ),
      ),
      body: /**SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: media.height/50,left: media.height/50,right: media.height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: crearElementos(tamanioTextField),
        ),
      )**/
      Container(
          height: media.height,
          width: media.width-media.height/50,
          //duration: Duration(seconds: 1),
          margin: MediaQuery.of(context).viewInsets,
          child: ListView(
              padding: EdgeInsets.only(top: media.height/50,left: media.height/50,right: media.height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
              scrollDirection: Axis.vertical,
              //itemCount: tamanioListView,
              shrinkWrap: true,
              //itemBuilder: (contexy,index){
              //return crearElemento(lista.elementos[index],tamanioTextField);
              //},
              children: [
                SizedBox(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: crearElementos(tamanioTextField),),)
              ],
          )
      ) ,
    );
  }

}
/**
 * import 'package:flutter/material.dart';
    import 'package:hambrout/main.dart';
    import 'package:hambrout/utils/formularios.dart';
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
    icon: const Icon(Icons.check_box_outlined, color: Colors.orange,))],),
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
    icon: const Icon(Icons.crop_square, color: Colors.orange,))],),
    Column(children: [SizedBox(width: tam, child: TextFormField(
    controller: elemento.controlador,
    onEditingComplete: (){terminaEdidion(elemento);}),)],)
    ],
    );
    }

    List<Widget> crearElementos(double tam){
    List<Widget> array=[];
    for(var elem in lista.elementos){
    array.add(crearElemento(elem, tam));
    }
    return array;
    }

    bool esListaVacia(){
    for(var e in lista.elementos){
    e.nombre=e.controlador.text;
    if(e.nombre!=''){
    return false;
    }
    }
    return true;
    }

    @override
    Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    double tamanioTextField = media.width/1.5;
    //tamanioListView = *lista.elementos.length;

    return Scaffold(
    appBar: AppBar(
    leading: GestureDetector(
    child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
    onTap: () {
    if(lista.elementos.last.controlador.text==''){
    lista.elementos.removeLast();
    }
    lista.titulo=tituloController.text;
    if(!esListaVacia()) {
    if(_formKey.currentState!.validate()){
    if(esNueva){
    conexionDatos.guardarListaNueva(lista);
    } else {
    conexionDatos.guardarLista(lista);
    }
    keys[2].currentState!.refreshPage();
    }
    } else{
    //prefs.setInt(l(DatosListas.id), id--);
    }
    Navigator.pop(context);
    },
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    title: Form(
    key: _formKey,
    child: TextFormField(
    decoration: InputDecoration(hintText: 'Titulo'),
    style: formatosDisenio.txtTituloLista(context),
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
    width: media.width,
    decoration: const BoxDecoration(color: Colors.white70),
    child: Padding(
    padding: EdgeInsets.all(media.height/50),
    child: ListView(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    children: crearElementos(tamanioTextField)
    ),
    ),
    ) ,
    );
    }

    }
 */